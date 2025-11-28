#!/bin/bash

# Set the script name
LOG_CALC="./logarithmic_calculation"

# Check execution permission
if [ ! -x "$LOG_CALC" ]; then
    echo "Error: ${LOG_CALC} is not executable." >&2
    exit 1
fi

echo "--- Testing Logarithmic Calculation Script ---"
echo ""

# Test Case 1: Basic addition (log2(8) + log10(100) = 3.0 + 2.0 = 5.0)
echo "## Test 1: Basic Addition"
INPUT_DATA="
= 8 2
+ 100 10
"
EXPECTED="5.000000"
RESULT=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>/dev/null)

if [ "$RESULT" == "$EXPECTED" ]; then
    echo "Success: Result $RESULT (Expected $EXPECTED)"
else
    echo "Failure: Result $RESULT (Expected $EXPECTED)" >&2
fi
echo "---"

# Test Case 2: Precision specification (log_e(e^2) * log_2(4) = 2.0 * 2.0 = 4.0)
echo "## Test 2: Precision Specification (-p 2)"
INPUT_DATA="
* 7.38905609893065 e # approx e^2
* 4 2
"
EXPECTED="4.00"
RESULT=$(echo -e "$INPUT_DATA" | "$LOG_CALC" -p 2 2>/dev/null)

if [ "$RESULT" == "$EXPECTED" ]; then
    echo "Success: Result $RESULT (Expected $EXPECTED)"
else
    echo "Failure: Result $RESULT (Expected $EXPECTED)" >&2
fi
echo "---"

# [cite_start]Test Case 3: Invalid argument (arg <= 0) - Should be skipped, resulting in no valid input processed [cite: 5, 12]
echo "## Test 3: Invalid Argument (arg <= 0) - Should result in 'No valid input processed'"
INPUT_DATA="
[cite_start]= 0 10 # Skipped [cite: 5]
- [cite_start]-5 2 # Skipped [cite: 5]
"
# Capture stderr
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
[cite_start]EXPECTED_STDERR="No valid input processed" [cite: 12]

if [[ "$RESULT_STDERR" =~ "$EXPECTED_STDERR" ]]; then
    echo "Success: Detected error message '$EXPECTED_STDERR'"
else
    echo "Failure: Unexpected output: $RESULT_STDERR" >&2
fi
echo "---"

# Test Case 4: Division by zero test (log(1)/log(b) = 0)
echo "## Test 4: Division by Zero"
INPUT_DATA="
= 100 10
[cite_start]/ 1 5 # log5(1) = 0.0, resulting in division by zero [cite: 9]
"
# Capture stderr and check exit code
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
EXIT_CODE=$?
[cite_start]EXPECTED_STDERR="Division by zero" [cite: 10]
[cite_start]EXPECTED_EXIT_CODE=1 [cite: 11]

if [[ "$RESULT_STDERR" =~ "$EXPECTED_STDERR" ]] && [ "$EXIT_CODE" -eq "$EXPECTED_EXIT_CODE" ]; then
    echo "Success: Detected error message '$EXPECTED_STDERR' and exit code $EXIT_CODE"
else
    echo "Failure: Unexpected output: $RESULT_STDERR, Exit code $EXIT_CODE (Expected $EXPECTED_EXIT_CODE)" >&2
fi
echo "---"

# [cite_start]Test Case 5: Invalid base (base = 1) test [cite: 2]
echo "## Test 5: Invalid Base (base = 1)"
INPUT_DATA="
[cite_start]= 10 1 # Base must be > 0 and not equal to 1. [cite: 2]
"
# Capture stderr and check exit code
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
EXIT_CODE=$?

# [cite_start]If the first line fails parsing, the result should be 'No valid input processed' [cite: 12]
EXPECTED_NO_INPUT_ERR="No valid input processed"
EXPECTED_BASE_ERR="Base must be > 0 and not equal to 1."

if [[ "$RESULT_STDERR" =~ "$EXPECTED_NO_INPUT_ERR" ]] && [ "$EXIT_CODE" -eq 1 ]; then
    echo "Success: Detected 'No valid input processed' after skipping the line due to invalid base."
elif [[ "$RESULT_STDERR" =~ "$EXPECTED_BASE_ERR" ]]; then
    # This case might happen if get_base raises ValueError and the outer try-except catches it
    echo "Success: Detected base error message '$EXPECTED_BASE_ERR' (or related warning)."
else
    echo "Failure: Unexpected output: $RESULT_STDERR, Exit code $EXIT_CODE" >&2
fi
echo "---"

echo "Tests complete."
