#!/bin/bash
LOG_CALC="./logarithmic_calculation" # ファイル名を修正
PASSED=0
FAILED=0
TOLERANCE="0.000001"

# LOG_CALCに実行権限があるか確認
if [ ! -x "$LOG_CALC" ]; then
    echo "Error: $LOG_CALC is not executable." >&2
    echo "Please ensure you run: chmod +x $LOG_CALC" >&2
    exit 1
fi

run_test() {
    TEST_NAME="$1"
    INPUT="$2"
    EXPECTED="$3"
    PRECISION="$4"

    # T7 のエラーテストは特別処理
    if [ "$TEST_NAME" == "T7_Error_DivByZero" ]; then
        RESULT=$(echo -e "$INPUT" | "$LOG_CALC" 2>/dev/null)
        if [ -z "$RESULT" ]; then
            echo "PASSED: $TEST_NAME (Error Handled)"
            PASSED=$((PASSED + 1))
        else
            echo "FAILED: $TEST_NAME (Error expected, but got: $RESULT)"
            FAILED=$((FAILED + 1))
        fi
        return
    fi
    
    # 正常系のテスト：結果を取得
    RESULT=$(echo -e "$INPUT" | "$LOG_CALC" -p "$PRECISION" 2>/dev/null)

    # AWKを使用して、許容誤差 TOLERANCE 内で数値比較を行う
    COMPARISON_RESULT=$(echo | awk -v R="$RESULT" -v E="$EXPECTED" -v T="$TOLERANCE" '
        BEGIN {
            # 期待値と結果の差の絶対値
            diff = (R > E) ? (R - E) : (E - R);
            # 差が許容誤差以下なら 1 を出力
            if (diff <= T) print 1; else print 0;
        }
    ')
    
    # COMPARISON_RESULT が 1 (許容誤差内) なら成功
    if [ "$COMPARISON_RESULT" == "1" ]; then
        echo "PASSED: $TEST_NAME"
        PASSED=$((PASSED + 1))
    else
        echo "FAILED: $TEST_NAME"
        echo "     Input: $INPUT"
        echo "     Expected: $EXPECTED (Tolerance: $TOLERANCE)"
        echo "     Got: $RESULT"
        FAILED=$((FAILED + 1))
    fi
}

echo "--- Starting Log Calculator Tests ---"
echo ""

# T1: 2.0 + 3.0 = 5.0
run_test "T1_Addition" "=,100,10
+,8,2" "5.00000" 5

# T2: 3.0 - 2.0 = 1.0
run_test "T2_Subtraction" "=,1000,10
-,100,10" "1.00000" 5

# T3: 2.0 * 2.0 = 4.0
run_test "T3_Multiplication" "=,100,10
*,4,2" "4.00000" 5

# T4: 4.0 / 1.0 = 4.0
run_test "T4_Division" "=,16,2
/,10,10" "4.00000" 5

# T5: (2.0 + 3.0) * 2.0 = 10.0
run_test "T5_MultiOp_Sequence" "=,100,10
+,8,2
*,100,10" "10.000" 3

# T6: 3.0
run_test "T6_Initial_Value" "=,1000,10" "3.00000" 5

# T7: log(1) = 0.0
run_test "T7_Final_Result_Zero" "=,1,10" "0.00000" 5 

# T7': ゼロ除算エラーテスト (log_val=0 で sys.exit(1) が呼ばれるため、RESULT は空文字列を期待)
run_test "T7_Error_DivByZero" "=,100,10
/,1,10" "" 5 

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
