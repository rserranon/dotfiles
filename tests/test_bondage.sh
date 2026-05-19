#!/usr/bin/env bash
# Tests: bondage launcher integrity — alias routing + pinned-binary hash freshness
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Bondage ===\033[0m\n"

if ! command -v bondage &>/dev/null; then
  warn "bondage not installed — skipping"
  printf "\nBondage: 0 passed, 0 failed (skipped)\n"
  exit 0
fi

# claude alias must route through `bondage exec` with the trailing `--`.
# A silent revert to raw `claude` would drop the sandbox without any test failing.
ALIASES="$DOTFILES_DIR/aliases/aliases"
if grep -qE "^alias claude='bondage exec claude .+\.conf --'" "$ALIASES"; then
  pass "claude alias routes through 'bondage exec' with trailing --"
else
  fail "claude alias does not route through 'bondage exec' (sandbox bypass risk)"
fi

CONF="$HOME/.config/bondage/bondage.conf"
if [[ -f "$CONF" ]]; then
  pass "bondage config present at ~/.config/bondage/bondage.conf"
else
  fail "bondage config missing at $CONF"
fi

# `bondage doctor` re-hashes every pinned binary against the config. Stale pins
# block `claude` from launching, but only at use time — this surfaces it earlier.
if [[ -f "$CONF" ]]; then
  if bondage doctor "$CONF" 2>&1 | grep -q "status: clean"; then
    pass "bondage doctor: pins clean"
  else
    fail "bondage doctor: pins stale — run 'bondage doctor $CONF' for the repin command"
  fi
fi

printf "\nBondage: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
