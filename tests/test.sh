#!/bin/bash
# Test script for CharGen

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0

# ---------------------------------------------------------------------------
# Helper: check exit code only
# ---------------------------------------------------------------------------
test_command() {
    local desc="$1"
    local cmd="$2"
    local expected_exit="$3"

    echo -n "Testing: $desc... "

    set +e
    eval "$cmd" > /dev/null 2>&1
    actual_exit=$?
    set -e

    if [ "$actual_exit" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${NC} (expected exit $expected_exit, got $actual_exit)"
        FAIL=$((FAIL + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper: run cmd, strip newlines from stdout, test against ERE regex
# Usage: test_output_matches "desc" "cmd" "regex"
# ---------------------------------------------------------------------------
test_output_matches() {
    local desc="$1"
    local cmd="$2"
    local regex="$3"

    echo -n "Testing: $desc... "

    set +e
    output=$(eval "$cmd" 2>/dev/null | tr -d '\n')
    cmd_exit=$?
    set -e

    if [ "$cmd_exit" -ne 0 ]; then
        echo -e "${RED}FAIL${NC} (command exited $cmd_exit)"
        FAIL=$((FAIL + 1))
        return
    fi

    if echo "$output" | grep -qE "$regex"; then
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${NC} (output '$output' did not match '$regex')"
        FAIL=$((FAIL + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper: run cmd, strip newlines, assert output does NOT match regex
# Usage: test_output_not_matches "desc" "cmd" "regex"
# ---------------------------------------------------------------------------
test_output_not_matches() {
    local desc="$1"
    local cmd="$2"
    local regex="$3"

    echo -n "Testing: $desc... "

    set +e
    output=$(eval "$cmd" 2>/dev/null | tr -d '\n')
    cmd_exit=$?
    set -e

    if [ "$cmd_exit" -ne 0 ]; then
        echo -e "${RED}FAIL${NC} (command exited $cmd_exit)"
        FAIL=$((FAIL + 1))
        return
    fi

    if echo "$output" | grep -qE "$regex"; then
        echo -e "${RED}FAIL${NC} (output '$output' matched forbidden pattern '$regex')"
        FAIL=$((FAIL + 1))
    else
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper: assert exact character count (after stripping newlines)
# Usage: test_length "desc" "cmd" expected_len
# ---------------------------------------------------------------------------
test_length() {
    local desc="$1"
    local cmd="$2"
    local expected_len="$3"

    echo -n "Testing: $desc... "

    set +e
    actual_len=$(eval "$cmd" 2>/dev/null | tr -d '\n' | wc -c)
    cmd_exit=$?
    set -e

    if [ "$cmd_exit" -ne 0 ]; then
        echo -e "${RED}FAIL${NC} (command exited $cmd_exit)"
        FAIL=$((FAIL + 1))
        return
    fi

    if [ "$actual_len" -eq "$expected_len" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${NC} (expected $expected_len chars, got $actual_len)"
        FAIL=$((FAIL + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper: assert two back-to-back invocations produce DIFFERENT output
# Usage: test_outputs_differ "desc" "cmd"
# ---------------------------------------------------------------------------
test_outputs_differ() {
    local desc="$1"
    local cmd="$2"

    echo -n "Testing: $desc... "

    set +e
    out1=$(eval "$cmd" 2>/dev/null | tr -d '\n')
    out2=$(eval "$cmd" 2>/dev/null | tr -d '\n')
    set -e

    if [ "$out1" != "$out2" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${NC} (both invocations produced identical output: '$out1')"
        FAIL=$((FAIL + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper: check that stderr of a failing command contains a substring
# Usage: test_stderr_contains "desc" "cmd" "substring" expected_exit
# ---------------------------------------------------------------------------
test_stderr_contains() {
    local desc="$1"
    local cmd="$2"
    local substr="$3"
    local expected_exit="$4"

    echo -n "Testing: $desc... "

    set +e
    stderr_out=$(eval "$cmd" 2>&1 >/dev/null)
    actual_exit=$?
    set -e

    local ok=1
    if [ "$actual_exit" -ne "$expected_exit" ]; then
        echo -e "${RED}FAIL${NC} (expected exit $expected_exit, got $actual_exit)"
        FAIL=$((FAIL + 1))
        return
    fi

    if echo "$stderr_out" | grep -qF "$substr"; then
        echo -e "${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${NC} (stderr '$stderr_out' did not contain '$substr')"
        FAIL=$((FAIL + 1))
    fi
}

# ===========================================================================
# Setup: build
# ===========================================================================
echo "========================================"
echo "CharGen Test Suite"
echo "========================================"
echo ""

echo "Building CharGen..."
cd "$(dirname "$0")/.." || exit 1
make clean > /dev/null 2>&1
make > /dev/null 2>&1

if [ ! -f "./chargen" ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Build successful${NC}"
echo ""

# ===========================================================================
# Basic functionality — exit-code tests
# ===========================================================================
echo "Running basic tests..."
test_command "Generate 10 characters"   "./chargen 10"   0
test_command "Generate 1 character"     "./chargen 1"    0
test_command "Generate 100 characters"  "./chargen 100"  0
test_command "Generate 1000 characters" "./chargen 1000" 0

# ===========================================================================
# Option tests — exit-code
# ===========================================================================
echo ""
echo "Testing options..."
test_command "Numeric only (-n)"       "./chargen -n 10"  0
test_command "Letters only (-c)"       "./chargen -c 10"  0
test_command "Special chars only (-s)" "./chargen -s 10"  0
test_command "Lowercase letters (-ci)" "./chargen -ci 10" 0
test_command "Uppercase letters (-ca)" "./chargen -ca 10" 0
test_command "Numbers + special (-ns)" "./chargen -ns 10" 0
test_command "Numbers + letters (-nc)" "./chargen -nc 10" 0

# ===========================================================================
# Help and version — exit-code
# ===========================================================================
echo ""
echo "Testing help and version..."
test_command "Help short option (-h)"       "./chargen -h"       0
test_command "Help long option (--help)"    "./chargen --help"   0
test_command "Version short option (-v)"    "./chargen -v"       0
test_command "Version long option (--version)" "./chargen --version" 0

# ===========================================================================
# Error cases — exit-code
# ===========================================================================
echo ""
echo "Testing error handling..."
test_command "No arguments"      "./chargen"      84
test_command "Negative number"   "./chargen -5"   84
test_command "Non-numeric argument" "./chargen abc" 84

# Zero count: program exits with error (no chars to generate)
test_command "Zero count"        "./chargen 0"    84

# Unknown flag must now be REJECTED (exit 84).
# NOTE: old test had this as exit 0 ("should ignore unknown flags") — that was
# wrong under the new behavior.  Flipped to 84.
test_command "Unknown flag rejected (-z)" "./chargen -z 10" 84

# -i or -a without -c must be rejected
test_command "-i without -c rejected"  "./chargen -i 10" 84
test_command "-a without -c rejected"  "./chargen -a 10" 84

# Confirm -ci and -ca (with -c) are still valid
test_command "-ci (lowercase with -c) accepted" "./chargen -ci 10" 0
test_command "-ca (uppercase with -c) accepted" "./chargen -ca 10" 0

# ===========================================================================
# Content validation — output must match expected character class
# (Use length 50 to stay comfortably below the 100-char newline wrap.
#  Newlines are stripped with tr -d '\n' before the regex check.)
# ===========================================================================
echo ""
echo "Testing output content (character-class validation)..."

test_output_matches \
    "Numeric output (-n 50) matches [0-9]+" \
    "./chargen -n 50" \
    '^[0-9]+$'

test_output_matches \
    "Letter output (-c 50) matches [a-zA-Z]+" \
    "./chargen -c 50" \
    '^[a-zA-Z]+$'

test_output_matches \
    "Lowercase output (-ci 50) matches [a-z]+" \
    "./chargen -ci 50" \
    '^[a-z]+$'

test_output_matches \
    "Uppercase output (-ca 50) matches [A-Z]+" \
    "./chargen -ca 50" \
    '^[A-Z]+$'

# Special chars: must NOT contain any alphanumeric character
test_output_not_matches \
    "Special-char output (-s 50) contains no alnum" \
    "./chargen -s 50" \
    '[a-zA-Z0-9]'

# ===========================================================================
# Length check
# ===========================================================================
echo ""
echo "Testing output length..."

test_length "25 chars (-n 25)"    "./chargen -n 25"  25
test_length "1 char (default 1)"  "./chargen 1"       1
test_length "50 chars (default)"  "./chargen 50"     50
test_length "1000 chars (default)" "./chargen 1000" 1000

# ===========================================================================
# Regression: same-second invocations must produce DIFFERENT output
# (Fixed by seeding RNG with time ^ getpid; this test locks that behavior.)
# ===========================================================================
echo ""
echo "Testing RNG uniqueness (regression)..."

test_outputs_differ \
    "Two back-to-back './chargen 30' differ (RNG seed regression)" \
    "./chargen 30"

# ===========================================================================
# Stderr content for rejected flags (spot-check messaging)
# ===========================================================================
echo ""
echo "Testing error messages..."

test_stderr_contains \
    "Unknown flag stderr says 'invalid option'" \
    "./chargen -z 10" \
    "invalid option" \
    84

# ===========================================================================
# --secure flag tests
# ===========================================================================
echo ""
echo "Testing --secure flag..."

# 1. --secure 20: exit 0 and exactly 20 chars
test_length \
    "--secure 20 produces exactly 20 chars" \
    "./chargen --secure 20" \
    20

# 2. --secure 50: exit 0 and exactly 50 chars (confirms it runs cleanly)
test_length \
    "--secure 50 produces exactly 50 chars" \
    "./chargen --secure 50" \
    50

# 3. --secure -n 40: numbers only
test_output_matches \
    "--secure -n 40 output matches [0-9]+" \
    "./chargen --secure -n 40" \
    '^[0-9]+$'

# 4. --secure -c 40: letters only
test_output_matches \
    "--secure -c 40 output matches [a-zA-Z]+" \
    "./chargen --secure -c 40" \
    '^[a-zA-Z]+$'

# 5. --secure -ci 40: lowercase only
test_output_matches \
    "--secure -ci 40 output matches [a-z]+" \
    "./chargen --secure -ci 40" \
    '^[a-z]+$'

# 6. Uniqueness: two invocations of --secure 30 differ
test_outputs_differ \
    "Two back-to-back './chargen --secure 30' differ (secure RNG uniqueness)" \
    "./chargen --secure 30"

# 7. Order independence: flag after count
test_length \
    "Count before flag: './chargen 12 --secure' produces 12 chars" \
    "./chargen 12 --secure" \
    12

# 8. --secure 10: stderr is empty (flag is not rejected as unknown)
test_command \
    "--secure 10 exits 0 (flag accepted)" \
    "./chargen --secure 10" \
    0

# ===========================================================================
# Summary
# ===========================================================================
echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo "Total tests: $((PASS + FAIL))"
echo -e "${GREEN}Passed: $PASS${NC}"
echo -e "${RED}Failed: $FAIL${NC}"

if [ $FAIL -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
fi
