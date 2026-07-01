#!/usr/bin/env bash
#
# japanese-voice.sh — interactive Japanese voice practice, backed by headless Claude Code.
#
#   mic ─▶ rec (sox) ─▶ whisper-cli (STT, ja) ─▶ claude -p (Opus) ─▶ say (TTS) ─▶ your ears
#
# The conversation logic, persona, error-correction style and difficulty calibration all
# come from the "Japanese Practice Mode" section of this repo's CLAUDE.md, which headless
# Claude loads automatically. This script is just the audio + orchestration shell around it.
#
# Runs immediately in TYPED mode (spoken replies) even with nothing installed; upgrades to
# full voice-in once you install the two deps below.
#
#   Full voice:   brew install sox whisper-cpp          (first run auto-downloads the model)
#   Mic access:   System Settings ▸ Privacy & Security ▸ Microphone ▸ enable your terminal app
#
# Config via env vars (all optional):
#   CLAUDE_MODEL=opus         model alias/name passed to claude
#   WHISPER_MODEL=small       ggml model: tiny|base|small|medium|large-v3-turbo (bigger = better ja, slower)
#   WHISPER_LANG=ja           STT language for spoken input (always Japanese practice)
#   VOICE=Kyoko               macOS `say` voice for Japanese (see: say -v '?')
#   SAY_RATE=175              speech rate, words/min
#   INPUT_MODE=auto           auto|voice|type  (auto = voice if deps present, else type)
#   MAX_THINKING_TOKENS=6000  best-effort extended-thinking budget for correction quality
#
# Usage:  ./japanese-voice.sh          then follow the prompts. Say/type 終わり or quit to end.

set -uo pipefail

# ── config ───────────────────────────────────────────────────────────────────
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"
WHISPER_MODEL="${WHISPER_MODEL:-small}"
WHISPER_LANG="${WHISPER_LANG:-ja}"     # spoken input is always Japanese practice
VOICE="${VOICE:-Kyoko}"                # spoken voice (Japanese only; English answers are text)
SAY_RATE="${SAY_RATE:-175}"
INPUT_MODE="${INPUT_MODE:-auto}"
export MAX_THINKING_TOKENS="${MAX_THINKING_TOKENS:-6000}"   # best-effort; ignored if unsupported

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d)"
WAV="$WORK/turn.wav"
STT_BASE="$WORK/turn"
MODEL_DIR="${WHISPER_MODEL_DIR:-$HOME/.cache/whisper}"
MODEL_PATH="$MODEL_DIR/ggml-$WHISPER_MODEL.bin"
LOG_DIR="$HOME/.zenbul-voice-logs"
LOG_FILE="$LOG_DIR/session-$(date +%Y%m%d-%H%M%S).md"

# ── pretty ───────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  B=$'\033[1m'; DIM=$'\033[2m'; GRN=$'\033[32m'; CYN=$'\033[36m'; YEL=$'\033[33m'; RED=$'\033[31m'; R=$'\033[0m'
else B=""; DIM=""; GRN=""; CYN=""; YEL=""; RED=""; R=""; fi

cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

# ── dependency detection ─────────────────────────────────────────────────────
command -v claude >/dev/null || { echo "${RED}claude not found on PATH. Install Claude Code first.${R}"; exit 1; }
command -v jq     >/dev/null || { echo "${RED}jq not found. brew install jq${R}"; exit 1; }

REC_BIN=""; command -v rec >/dev/null && REC_BIN="rec"
WHISPER_BIN=""
for c in whisper-cli whisper-cpp main; do command -v "$c" >/dev/null && { WHISPER_BIN="$c"; break; }; done

# Decide effective input mode.
MODE="type"
if [[ "$INPUT_MODE" == "voice" ]]; then
  MODE="voice"
elif [[ "$INPUT_MODE" == "type" ]]; then
  MODE="type"
else # auto
  [[ -n "$REC_BIN" && -n "$WHISPER_BIN" ]] && MODE="voice"
fi

# ── whisper model bootstrap (voice mode only) ────────────────────────────────
ensure_model() {
  [[ -f "$MODEL_PATH" ]] && return 0
  mkdir -p "$MODEL_DIR"
  local url="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${WHISPER_MODEL}.bin"
  echo "${YEL}First run: downloading whisper model '${WHISPER_MODEL}' (~a few hundred MB)…${R}"
  echo "${DIM}$url${R}"
  if ! curl -L --fail --progress-bar -o "$MODEL_PATH" "$url"; then
    echo "${RED}Model download failed. Falling back to typed input.${R}"
    rm -f "$MODEL_PATH"
    MODE="type"
  fi
}
[[ "$MODE" == "voice" ]] && ensure_model

# ── audio helpers ────────────────────────────────────────────────────────────
# Push-to-talk: Enter to start, Enter to stop. Returns transcribed text on stdout.
record_and_transcribe() {
  rm -f "$WAV" "$STT_BASE".txt
  "$REC_BIN" -q -c 1 -r 16000 -b 16 "$WAV" >/dev/null 2>&1 &
  local rpid=$!
  read -r -p "  ${RED}⏺  recording — Enter to stop${R} " _ </dev/tty
  kill -INT "$rpid" 2>/dev/null; wait "$rpid" 2>/dev/null
  [[ -s "$WAV" ]] || { echo ""; return; }
  printf '  %stranscribing…%s\r' "$DIM" "$R" >&2
  "$WHISPER_BIN" -m "$MODEL_PATH" -l "$WHISPER_LANG" -nt -otxt -of "$STT_BASE" "$WAV" >/dev/null 2>&1
  # collapse, trim, and drop whisper's silence/hallucination artifacts
  local txt; txt="$(tr '\n' ' ' < "$STT_BASE.txt" 2>/dev/null | sed -E 's/\[[^]]*\]//g; s/^[[:space:]]+//; s/[[:space:]]+$//')"
  case "$txt" in
    ""|"ご視聴ありがとうございました"|"おわり") ;;  # let caller handle empties
  esac
  printf '%s' "$txt"
}

# speak <text> [lang]   only Japanese is ever spoken; English answers stay on-screen as text
speak() {
  local text="$1" lang="${2:-ja}"
  [[ "$lang" == "ja" ]] || return
  [[ -n "${text//[[:space:]]/}" ]] || return
  say -v "$VOICE" -r "$SAY_RATE" "$text"
}

# ── claude backend ───────────────────────────────────────────────────────────
IFS= read -r -d '' SYS <<'EOF'
You are the spoken-conversation backend for a Japanese VOICE practice session. Obey the
"Japanese Practice Mode" section of CLAUDE.md (intermediate learner; ✗→✓ correction style;
difficulty calibration; scenario role-play; debrief on ending).

The learner's utterance this turn arrived via speech-to-text and MAY be mis-transcribed. Be
charitable: if a Japanese practice attempt has a garbled word, treat it as a mishearing and
ask for clarification — never flag a likely transcription artifact as a grammar mistake.

The learner uses two channels for two distinct purposes — handle each accordingly:
  (A) SPOKEN Japanese = a practice attempt. Reply in hiragana Japanese and give corrections
      exactly as specified below. This reply is spoken aloud. Set say_lang to "ja".
  (B) TYPED English = a question or request (e.g. "why is it たべました?", "how do I say I'm
      tired?", "can we do a cafe scenario?", "what did that mean?"). Answer it directly and
      clearly as their teacher, in English (include hiragana examples where useful). This
      answer is shown as TEXT, not spoken. Do NOT role-play, do NOT translate their question
      back at them, and put なし in corrections — a question is not a mistake. A brief nudge
      back to practice is welcome. Set say_lang to "en".
If a rare input does not fit its usual channel (e.g. typed Japanese, or a spoken English aside),
judge by content — practice attempt vs. question — and set say_lang to the language you reply in.

Spoken Japanese replies are read aloud by a TTS voice, so keep those conversational and short
(about 1–4 sentences), with no lists or meta narration. Typed English questions get a TEXT
answer that is NOT spoken, so it can be a little longer when the question needs it.

IMPORTANT — the learner CANNOT read kanji. Write EVERY piece of Japanese you produce (say,
display and corrections) in HIRAGANA ONLY — no kanji anywhere. Use katakana only for words
normally written in katakana (loanwords, foreign names). This overrides any furigana guidance
in CLAUDE.md.

Respond with ONE raw JSON object and NOTHING else — no prose, no markdown, no code fences:
{
  "say":         "<text to speak aloud: plain hiragana with no spaces for a JA reply, or plain English for an EN answer>",
  "say_lang":    "<'ja' or 'en' — the language of the say field, so the correct TTS voice is used>",
  "display":     "<on-screen text: a JA reply spaced word-by-word in hiragana; or the English answer, with any Japanese examples in hiragana>",
  "romaji":      "<romaji of say when say_lang is ja; otherwise an empty string>",
  "translation": "<one-line English gloss when say_lang is ja; otherwise an empty string>",
  "corrections": "<see the format below; use なし for a question/aside or when nothing is worth noting; never invent errors from mishearings>"
}

Corrections format — for each issue in the learner's latest utterance, output these lines:
  ✗ <what they said, in hiragana> → ✓ <the natural version, in hiragana>
  EN: <English translation of the corrected sentence>
  — <one-line explanation IN ENGLISH of why it is more natural>
If the utterance has more than one sentence, correct and translate each sentence separately.
Think carefully about the learner's grammar and word choice before writing corrections.
EOF

SESSION_ID=""
# ask_claude <prompt-text>  → sets globals SAY DISPLAY ROMAJI TRANSLATION CORRECTIONS
ask_claude() {
  local prompt="$1" raw inner clean
  if [[ -z "$SESSION_ID" ]]; then
    raw="$(cd "$REPO_DIR" && claude -p "$prompt" --model "$CLAUDE_MODEL" \
             --append-system-prompt "$SYS" --output-format json 2>/dev/null)"
    SESSION_ID="$(printf '%s' "$raw" | jq -r '.session_id // empty' 2>/dev/null)"
  else
    raw="$(cd "$REPO_DIR" && claude -p --resume "$SESSION_ID" "$prompt" --model "$CLAUDE_MODEL" \
             --append-system-prompt "$SYS" --output-format json 2>/dev/null)"
  fi
  inner="$(printf '%s' "$raw" | jq -r '.result // empty' 2>/dev/null)"
  clean="$(printf '%s' "$inner" | sed -E 's/^[[:space:]]*```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')"
  SAY="$(printf '%s' "$clean" | jq -r '.say // empty' 2>/dev/null)"
  if [[ -z "$SAY" ]]; then          # model didn't return JSON — treat as plain text
    SAY="${inner:-（へんじが ありませんでした）}"; DISPLAY="$SAY"; ROMAJI=""; TRANSLATION=""; CORRECTIONS=""; SAY_LANG="ja"
    return
  fi
  SAY_LANG="$(printf '%s' "$clean" | jq -r '.say_lang // "ja"' 2>/dev/null)"
  DISPLAY="$(printf '%s' "$clean" | jq -r '.display // .say' 2>/dev/null)"
  ROMAJI="$(printf '%s' "$clean" | jq -r '.romaji // empty' 2>/dev/null)"
  TRANSLATION="$(printf '%s' "$clean" | jq -r '.translation // empty' 2>/dev/null)"
  CORRECTIONS="$(printf '%s' "$clean" | jq -r '.corrections // empty' 2>/dev/null)"
}

render() { # prints the assistant turn + logs it
  echo
  echo "  ${B}${CYN}せんせい:${R} ${DISPLAY}"
  [[ -n "$ROMAJI"      ]] && echo "  ${DIM}${ROMAJI}${R}"
  [[ -n "$TRANSLATION" ]] && echo "  ${DIM}(${TRANSLATION})${R}"
  if [[ -n "$CORRECTIONS" && "$CORRECTIONS" != "なし" ]]; then
    echo
    echo "  ${YEL}${B}Corrections${R}"
    printf '%s\n' "$CORRECTIONS" | sed 's/^/  /'
  fi
  echo
  { echo "### せんせい"; echo "$DISPLAY"; [[ -n "$CORRECTIONS" ]] && { echo; echo "**Corrections:** $CORRECTIONS"; }; echo; } >> "$LOG_FILE"
}

is_quit() { case "${1//[[:space:]]/}" in quit|exit|bye|end|終わり|おわり|"もう終わり"|"終わりです") return 0;; *) return 1;; esac; }

# ── run ──────────────────────────────────────────────────────────────────────
mkdir -p "$LOG_DIR"; { echo "# Japanese voice session — $(date)"; echo; } >> "$LOG_FILE"

echo "${B}にほんご ボイスれんしゅう${R}  ${DIM}(model: $CLAUDE_MODEL · input: $MODE · voice: $VOICE)${R}"
if [[ "$MODE" == "type" ]]; then
  if [[ "$INPUT_MODE" == "auto" ]]; then
    echo "${DIM}Voice input off (missing: ${REC_BIN:+}${REC_BIN:-sox}${WHISPER_BIN:+}${WHISPER_BIN:-/whisper-cpp}). Typed input, spoken replies.${R}"
    echo "${DIM}Enable full voice:  brew install sox whisper-cpp${R}"
  fi
  echo "${DIM}Type Japanese to practice, or an English question for a text answer. Type 終わり or quit to finish.${R}"
else
  echo "${DIM}Press Enter and speak Japanese to practice — or type an English question for a text answer. Say 終わり to finish.${R}"
fi

# Opening turn (no user utterance yet).
ask_claude "[SESSION START — no user utterance yet. Greet the learner in Japanese and ask one opening question to begin the voice practice. Set corrections to なし.]"
render
speak "$SAY"

while true; do
  if [[ "$MODE" == "voice" ]]; then
    read -r -p "  ${GRN}▶︎ Enter, then speak Japanese${R}${DIM} · or type an English question:${R} " typed </dev/tty || break
    if [[ -n "${typed//[[:space:]]/}" ]]; then
      user_text="$typed"
    else
      user_text="$(record_and_transcribe)"
      [[ -z "${user_text//[[:space:]]/}" ]] && { echo "  ${DIM}(nothing heard — try again)${R}"; continue; }
      echo "  ${GRN}あなた:${R} $user_text"
    fi
  else
    read -r -p "  ${GRN}あなた:${R} " user_text </dev/tty || break
  fi

  [[ -z "${user_text//[[:space:]]/}" ]] && continue
  echo "### あなた: $user_text" >> "$LOG_FILE"

  if is_quit "$user_text"; then
    ask_claude "[SESSION END — the learner said: \"$user_text\". Give a short spoken debrief per CLAUDE.md's ending rules: what went well, one thing to keep working on, and an optional suggested next drill. Keep \`say\` to about 3 sentences. corrections: なし.]"
    render
    speak "$SAY" "$SAY_LANG"
    echo "  ${DIM}おつかれさまでした！ Transcript: $LOG_FILE${R}"
    break
  fi

  ask_claude "$user_text"
  render
  speak "$SAY" "$SAY_LANG"
done
