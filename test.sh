#!/bin/bash
# Test script for CharGen

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0

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

echo "========================================"
echo "CharGen Test Suite"
echo "========================================"
echo ""

# Build first
echo "Building CharGen..."
make clean > /dev/null 2>&1
make > /dev/null 2>&1

if [ ! -f "./chargen" ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Build successful${NC}"
echo ""

# Basic functionality tests
echo "Running basic tests..."
test_command "Generate 10 characters" "./chargen 10" 0
test_command "Generate 1 character" "./chargen 1" 0
test_command "Generate 100 characters" "./chargen 100" 0
test_command "Generate 1000 characters" "./chargen 1000" 0

# Option tests
echo ""
echo "Testing options..."
test_command "Numeric only (-n)" "./chargen -n 10" 0
test_command "Letters only (-c)" "./chargen -c 10" 0
test_command "Special chars only (-s)" "./chargen -s 10" 0
test_command "Lowercase letters (-ci)" "./chargen -ci 10" 0
test_command "Uppercase letters (-ca)" "./chargen -ca 10" 0
test_command "Numbers + special (-ns)" "./chargen -ns 10" 0
test_command "Numbers + letters (-nc)" "./chargen -nc 10" 0

# Help and version
echo ""
echo "Testing help and version..."
test_command "Help short option (-h)" "./chargen -h" 0
test_command "Help long option (--help)" "./chargen --help" 0
test_command "Version short option (-v)" "./chargen -v" 0
test_command "Version long option (--version)" "./chargen --version" 0

# Error cases
echo ""
echo "Testing error handling..."
test_command "No arguments" "./chargen" 84
test_command "Negative number" "./chargen -5" 84
test_command "Zero" "./chargen 0" 84
test_command "Non-numeric argument" "./chargen abc" 84
test_command "Invalid option" "./chargen -z 10" 0  # Should ignore unknown flags

# Output validation tests
echo ""
echo "Testing output validation..."

# Test numeric only output
output=$(./chargen -n 20)
if echo "$output" | grep -qE '^[0-9]+$'; then
    echo -e "Numeric output validation... ${GREEN}PASS${NC}"
    PASS=$((PASS + 1))
else
    echo -e "Numeric output validation... ${RED}FAIL${NC}"
    FAIL=$((FAIL + 1))
fi

# Test lowercase only output
output=$(./chargen -ci 20)
if echo "$output" | grep -qE '^[a-z]+$'; then
    echo -e "Lowercase output validation... ${GREEN}PASS${NC}"
    PASS=$((PASS + 1))
else
    echo -e "Lowercase output validation... ${RED}FAIL${NC}"
    FAIL=$((FAIL + 1))
fi

# Test uppercase only output
output=$(./chargen -ca 20)
if echo "$output" | grep -qE '^[A-Z]+$'; then
    echo -e "Uppercase output validation... ${GREEN}PASS${NC}"
    PASS=$((PASS + 1))
else
    echo -e "Uppercase output validation... ${RED}FAIL${NC}"
    FAIL=$((FAIL + 1))
fi

# Test output length
output=$(./chargen 50 | tr -d '\n' | wc -c)
if [ "$output" -eq 50 ]; then
    echo -e "Output length validation... ${GREEN}PASS${NC}"
    PASS=$((PASS + 1))
else
    echo -e "Output length validation... ${RED}FAIL${NC} (expected 50, got $output)"
    FAIL=$((FAIL + 1))
fi

# Summary
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
