#!/bin/bash
LOG_CALC="./log_calc.py"
PASSED=0
FAILED=0

run_test() {
    TEST_NAME="$1"
    INPUT="$2"
    EXPECTED="$3"
    PRECISION="$4"

    RESULT=$(echo -e "$INPUT" | "$LOG_CALC" -p "$PRECISION" 2>/dev/null)
    
    if [ "$RESULT" == "$EXPECTED" ]; then
        echo "PASSED: $TEST_NAME"
        PASSED=$((PASSED + 1))
    else
        echo "FAILED: $TEST_NAME"
        echo "   Input: $INPUT"
        echo "   Expected: $EXPECTED"
        echo "   Got: $RESULT"
        FAILED=$((FAILED + 1))
    fi
}

echo "--- Starting Log Calculator Tests ---"
echo ""


run_test "T1_Addition" "
=,100,10
+,8,2
" "5.00000" 5


run_test "T2_Subtraction" "
=,54.598,e
-,100,10
" "2.00000" 5


run_test "T3_Multiplication" "
=,100,10
*,4,2
" "4.00000" 5


run_test "T4_Division" "
=,16,2
/,10,10
" "4.00000" 5


run_test "T5_MultiOp_Sequence" "
=,100,10
+,8,2
*,7.389056,e
" "10.000" 3


run_test "T6_Initial_Value" "=,1000,10" "3.00000" 5


run_test "T7_Error_DivByZero_Log" "
=,100,10
/,1,10
" "0.00000" 5 

echo ""
echo "--- Test Summary ---"
echo "Total Tests: $((PASSED + FAILED))"
echo "PASSED: $PASSED"
echo "FAILED: $FAILED"

if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
