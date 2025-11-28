# Set the script name
# SPDX-FileCopyrightText: 2025 Eiki Nakayama <qwertyuiop1103566@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only


LOG_CALC="./logarithmic_calculation"

# Check execution permission
if [ ! -x "$LOG_CALC" ]; then
    echo "Error: ${LOG_CALC} is not executable." >&2 [cite: 19, 20]
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
# 2>/dev/null は stderr を破棄
RESULT=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>/dev/null)

if [ "$RESULT" == "$EXPECTED" ]; then [cite: 21]
    echo "Success: Result $RESULT (Expected $EXPECTED)"
else
    echo "Failure: Result $RESULT (Expected $EXPECTED)" >&2
fi
echo "---"



# Test Case 2: Invalid argument (arg <= 0) - Should be skipped, resulting in no valid input processed 
echo "## Test 2: Invalid Argument (arg <= 0) - Should result in 'No valid input processed'"
INPUT_DATA="
= 0 10 
- -5 2 
"
# Capture stderr
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
EXPECTED_STDERR="No valid input processed" 

if [[ "$RESULT_STDERR" =~ "$EXPECTED_STDERR" ]]; then [cite: 24]
    echo "Success: Detected error message '$EXPECTED_STDERR'"
else
    echo "Failure: Unexpected output: $RESULT_STDERR" >&2
fi
echo "---"

# Test Case 3: Division by zero test (log(1)/log(b) = 0)
echo "## Test 3: Division by Zero"
INPUT_DATA="
= 100 10
/ 1 5 # log5(1) = 0.0, resulting in division by zero
"
# Capture stderr and check exit code
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
EXIT_CODE=$?
EXPECTED_STDERR="Division by zero"
EXPECTED_EXIT_CODE=1

if [[ "$RESULT_STDERR" =~ "$EXPECTED_STDERR" ]] && [ "$EXIT_CODE" -eq "$EXPECTED_EXIT_CODE" ]; then [cite: 25, 26]
    echo "Success: Detected error message '$EXPECTED_STDERR' and exit code $EXIT_CODE"
else
    echo "Failure: Unexpected output: $RESULT_STDERR, Exit code $EXIT_CODE (Expected $EXPECTED_EXIT_CODE)" >&2
fi
echo "---"

# Test Case 4: Invalid base (base = 1) test
echo "## Test 4: Invalid Base (base = 1)"
INPUT_DATA="
= 10 1 # Base must be > 0 and not equal to 1.
"
# Capture stderr and check exit code
RESULT_STDERR=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>&1 >/dev/null)
EXIT_CODE=$?
# 最初の行で無効な基数エラーが発生し、行がスキップされ、結果として有効な入力がない状態になる [cite: 6, 16, 17]
EXPECTED_NO_INPUT_ERR="No valid input processed"
EXPECTED_EXIT_CODE=1

if [[ "$RESULT_STDERR" =~ "$EXPECTED_NO_INPUT_ERR" ]] && [ "$EXIT_CODE" -eq "$EXPECTED_EXIT_CODE" ]; then [cite: 28, 29]
    echo "Success: Detected '$EXPECTED_NO_INPUT_ERR' and exit code $EXPECTED_EXIT_CODE."
else
    echo "Failure: Unexpected output: $RESULT_STDERR, Exit code $EXIT_CODE (Expected $EXPECTED_EXIT_CODE)" >&2
fi
echo "---"

# Test Case 5: Power calculation (log2(16) ^ log10(100) = 4^2 = 16.0)
echo "## Test 5: Power Calculation (^)"
INPUT_DATA="
= 16 2 # log2(16) = 4
^ 100 10 # log10(100) = 2
"
EXPECTED="16.000000"
RESULT=$(echo -e "$INPUT_DATA" | "$LOG_CALC" 2>/dev/null)

if [ "$RESULT" == "$EXPECTED" ]; then
    echo "Success: Result $RESULT (Expected $EXPECTED)"
else
    echo "Failure: Result $RESULT (Expected $EXPECTED)" >&2
fi
echo "---"



echo "Tests complete."
