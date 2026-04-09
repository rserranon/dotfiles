#!/usr/bin/env bash
# Master test runner — executes all dotfiles test scripts and reports results
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0
FAILED_SUITES=()

run_suite() {
  local script="$TESTS_DIR/$1"
  local name="$2"
  echo ""
  if bash "$script"; then
    TOTAL_PASS=$((TOTAL_PASS+1))
  else
    TOTAL_FAIL=$((TOTAL_FAIL+1))
    FAILED_SUITES+=("$name")
  fi
}

echo "╔══════════════════════════════════════╗"
echo "║     dotfiles test suite              ║"
echo "╚══════════════════════════════════════╝"

run_suite test_json.sh  "JSON syntax"
run_suite test_zsh.sh   "Zsh config"
run_suite test_tmux.sh  "Tmux config"
run_suite test_nvim.sh  "Neovim/Lua"
run_suite test_tools.sh "Tool availability"
run_suite test_stow.sh  "Stow layout"

echo ""
echo "══════════════════════════════════════"
if [[ $TOTAL_FAIL -eq 0 ]]; then
  printf "\033[32m✓ All suites passed (%d/%d)\033[0m\n" "$TOTAL_PASS" "$((TOTAL_PASS+TOTAL_FAIL))"
else
  printf "\033[31m✗ %d suite(s) failed: %s\033[0m\n" \
    "$TOTAL_FAIL" "${FAILED_SUITES[*]}"
fi
echo "══════════════════════════════════════"

[[ $TOTAL_FAIL -eq 0 ]]
