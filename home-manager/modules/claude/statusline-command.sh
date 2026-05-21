#!/usr/bin/env bash
# Claude Code statusline styled after Tide Fish prompt.

INPUT=$(cat)

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
CTX_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

file_mtime() {
  stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null
}

parse_iso_to_epoch() {
  # GNU date understands ISO-8601 directly
  local out
  out=$(date -d "$1" +%s 2>/dev/null) && [ -n "$out" ] && {
    echo "$out"
    return
  }

  # BSD date needs a stripped form
  local clean
  clean=$(echo "$1" | sed 's/\.[0-9]*//; s/:\([0-9][0-9]\)$/\1/')
  date -jf "%Y-%m-%dT%H:%M:%S%z" "$clean" +%s 2>/dev/null
}

fetch_oauth_token() {
  if command -v security >/dev/null 2>&1; then
    security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null |
      jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null
    return
  fi

  local f="$HOME/.claude/.credentials.json"
  [ -r "$f" ] && jq -r '.claudeAiOauth.accessToken // empty' "$f" 2>/dev/null
}

# --- Separator ---
S="\x1b[38;2;88;88;88m \xe2\x94\x82 \x1b[0m"

# --- Path (Tide-style) ---
DIR="${CWD/#$HOME/~}"
PARENT=$(dirname "$DIR" | sed 's|.*/||')
BASE=$(basename "$DIR")
if [ "$DIR" = "~" ]; then
  P="\x1b[38;2;0;175;255m~\x1b[0m"
elif [ "$PARENT" = "/" ] || [ "$PARENT" = "." ]; then
  P="\x1b[38;2;0;175;255m${BASE}\x1b[0m"
else
  P="\x1b[38;2;0;135;175m${PARENT}/\x1b[38;2;0;175;255m${BASE}\x1b[0m"
fi

G=""
if git -C "$CWD" rev-parse --is-inside-work-tree &>/dev/null; then
  BRANCH=$(git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null || git -C "$CWD" rev-parse --short HEAD 2>/dev/null)
  if ! git -C "$CWD" diff --quiet 2>/dev/null || ! git -C "$CWD" diff --cached --quiet 2>/dev/null; then
    G="${S}\x1b[38;2;215;175;0m ${BRANCH}\x1b[0m"
  else
    G="${S}\x1b[38;2;95;215;0m ${BRANCH}\x1b[0m"
  fi
fi

if [ "$CTX_PCT" -ge 80 ] 2>/dev/null; then
  CC="38;2;255;0;0"
elif [ "$CTX_PCT" -ge 50 ] 2>/dev/null; then
  CC="38;2;215;175;0"
else
  CC="38;2;95;215;0"
fi
CTX="${S}\x1b[${CC}m${CTX_PCT}%%\x1b[0m"

CACHE_FILE="${TMPDIR:-/tmp}/claude-usage-cache"
CACHE_MAX_AGE=60
USAGE=""

fetch_usage() {
  local TOKEN
  TOKEN=$(fetch_oauth_token)
  [ -z "$TOKEN" ] && return

  curl -s --max-time 3 "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "Content-Type: application/json" >"$CACHE_FILE.tmp" 2>/dev/null

  if [ -s "$CACHE_FILE.tmp" ] && jq -e '.five_hour' "$CACHE_FILE.tmp" &>/dev/null; then
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
    rm -f "$CACHE_FILE.err"
  elif [ -s "$CACHE_FILE.tmp" ] && jq -e '.error.type == "rate_limit_error"' "$CACHE_FILE.tmp" &>/dev/null; then
    mv "$CACHE_FILE.tmp" "$CACHE_FILE.err"
  else
    rm -f "$CACHE_FILE.tmp"
  fi
}

CACHE_MTIME=$(file_mtime "$CACHE_FILE")
CACHE_MTIME=${CACHE_MTIME:-0}
if [ ! -f "$CACHE_FILE" ] || [ $(($(date +%s) - CACHE_MTIME)) -gt $CACHE_MAX_AGE ]; then
  fetch_usage
fi

if [ -f "$CACHE_FILE" ]; then
  FIVE_H=$(jq -r '.five_hour.utilization // empty' "$CACHE_FILE" 2>/dev/null | cut -d. -f1)
  RESET_AT=$(jq -r '.five_hour.resets_at // empty' "$CACHE_FILE" 2>/dev/null)

  if [ -n "$FIVE_H" ]; then
    if [ "$FIVE_H" -ge 80 ] 2>/dev/null; then
      UC="38;2;255;0;0"
    elif [ "$FIVE_H" -ge 50 ] 2>/dev/null; then
      UC="38;2;215;175;0"
    else
      UC="38;2;95;215;0"
    fi

    RESET=""
    if [ -n "$RESET_AT" ]; then
      RESET_EPOCH=$(parse_iso_to_epoch "$RESET_AT")
      if [ -n "$RESET_EPOCH" ]; then
        NOW=$(date +%s)
        DIFF_MIN=$(((RESET_EPOCH - NOW) / 60))
        [ "$DIFF_MIN" -lt 0 ] && DIFF_MIN=0
        HOURS=$((DIFF_MIN / 60))
        MINS=$((DIFF_MIN % 60))
        if [ "$HOURS" -gt 0 ]; then
          RESET="${S}\x1b[38;2;148;148;148mResets in ${HOURS}h${MINS}m\x1b[0m"
        else
          RESET="${S}\x1b[38;2;148;148;148mResets in ${MINS}m\x1b[0m"
        fi
      fi
    fi

    USAGE="${S}\x1b[${UC}m${FIVE_H}/100%%\x1b[0m${RESET}"
  fi
elif [ -f "$CACHE_FILE.err" ]; then
  USAGE="${S}\x1b[38;2;255;0;0mRate limited\x1b[0m"
fi

printf "${P}${G}${CTX}${USAGE}"
