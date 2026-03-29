#!/bin/bash
# Test harness — feeds fake JSON to the statusline script and captures output

SCRIPT="$(dirname "$0")/quota-statusline.sh"

pass=0
fail=0

assert_contains() {
  local label="$1" input="$2" expected="$3"
  local output
  output=$(echo "$input" | bash "$SCRIPT" 2>/dev/null)
  if [[ "$output" == *"$expected"* ]]; then
    echo "PASS: $label"
    ((pass++))
  else
    echo "FAIL: $label"
    echo "  expected to contain: $expected"
    echo "  got: $output"
    ((fail++))
  fi
}

# Test: both windows present
assert_contains "both windows" \
  '{"rate_limits":{"five_hour":{"used_percentage":67},"seven_day":{"used_percentage":20}}}' \
  "5h:"

assert_contains "both windows has 7d" \
  '{"rate_limits":{"five_hour":{"used_percentage":67},"seven_day":{"used_percentage":20}}}' \
  "7d:"

assert_contains "both windows has separator" \
  '{"rate_limits":{"five_hour":{"used_percentage":67},"seven_day":{"used_percentage":20}}}' \
  "│"

# Test: only 5h present
assert_contains "only 5h" \
  '{"rate_limits":{"five_hour":{"used_percentage":50}}}' \
  "5h:"

# Test: no data — waiting message
assert_contains "no data" \
  '{"something":"else"}' \
  "waiting"

# Test: 0% — all empty blocks
assert_contains "0 pct has 0%" \
  '{"rate_limits":{"five_hour":{"used_percentage":0}}}' \
  "0%"

# Test: 100% — all filled blocks
assert_contains "100 pct has 100%" \
  '{"rate_limits":{"five_hour":{"used_percentage":100}}}' \
  "100%"

echo ""
echo "Results: $pass passed, $fail failed"
[[ $fail -eq 0 ]] && exit 0 || exit 1
