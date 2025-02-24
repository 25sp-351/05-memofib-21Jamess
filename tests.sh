#!/bin/bash

if [ ! -x fibonacci ]; then
    echo "Compiling fibonacci..."
    gcc -o fibonacci fibonacci.c || exit 1
fi

tests_passed=0
tests_total=0

# Function for testing valid inputs.
run_test() {
    tests_total=$((tests_total+1))
    input="$1"
    expected="$2"
    output=$(./fibonacci "$input" 2>&1)
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Test $tests_total (input='$input'): FAILED (exit code $exit_code)"
        echo "  Output: $output"
    elif [[ "$output" == *"$expected"* ]]; then
        echo "Test $tests_total (input='$input'): PASSED"
        tests_passed=$((tests_passed+1))
    else
        echo "Test $tests_total (input='$input'): FAILED"
        echo "  Expected to include: $expected"
        echo "  Output: $output"
    fi
}

# Function for testing invalid inputs.
run_invalid_test() {
    tests_total=$((tests_total+1))
    input="$1"
    output=$(./fibonacci "$input" 2>&1)
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "Test $tests_total (input='$input'): FAILED (expected nonzero exit code)"
        echo "  Output: $output"
    elif [[ "$output" == *"Usage:"* ]]; then
        echo "Test $tests_total (input='$input'): PASSED"
        tests_passed=$((tests_passed+1))
    else
        echo "Test $tests_total (input='$input'): FAILED"
        echo "  Expected a usage message in the output."
        echo "  Output: $output"
    fi
}

echo "Running valid input tests..."
run_test "0"  "Fibonacci(0) = 0"
run_test "1"  "Fibonacci(1) = 1"
run_test "5"  "Fibonacci(5) = 5"
run_test "10" "Fibonacci(10) = 55"
run_test "20" "Fibonacci(20) = 6765"
run_test "91" "Fibonacci(91) = 4660046610375530309"

echo ""
echo "Running invalid input tests..."
run_invalid_test "-5"
run_invalid_test "abc"
run_invalid_test ""

echo ""
echo "Summary: $tests_passed / $tests_total tests passed."
[ $tests_passed -eq $tests_total ]
