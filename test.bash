#!/bin/bash
LOG_CALC="./logarithmic_calculation"
PASSED=0
FAILED=0
# 許容誤差を 10^-6 に戻す (厳しすぎると逆に失敗しやすい)
TOLERANCE="0.000001" 

if [ ! -f "$LOG_CALC" ]; then
    echo "Error: Python script $LOG_CALC not found." >&2
    exit 1
fi

run_test() {
    TEST_NAME="$1"
    INPUT="$2"
    EXPECTED="$3"
    PRECISION="$4"

    # T7: ゼロ除算エラーテスト
    if [ "$TEST_NAME" == "T7_Error_DivByZero" ]; then
        # エラーメッセージが標準エラー出力に出ることを確認し、標準出力が空であることを確認
        RESULT=$(echo -n "$INPUT" | python3 "$LOG_CALC" 2> /tmp/log_calc_error.log)
        ERROR_OUTPUT=$(cat /tmp/log_calc_error.log)
        
        # 実行が失敗し（$? != 0）、標準エラー出力にエラーメッセージが含まれていることをチェック
        if [ $? -ne 0 ] && [ -n "$ERROR_OUTPUT" ]; then
            echo "PASSED: $TEST_NAME (Error Handled)"
            PASSED=$((PASSED + 1))
        else
            echo "FAILED: $TEST_NAME (Expected error, but got: RESULT='$RESULT', ERROR='$ERROR_OUTPUT')"
            FAILED=$((FAILED + 1))
        fi
        return
    fi
    
    # 正常系のテスト：結果を取得
    RESULT=$(echo -n "$INPUT" | python3 "$LOG_CALC" -p "$PRECISION" 2>/dev/null)

    # AWKを使用して、許容誤差 TOLERANCE 内で数値比較を行う
    COMPARISON_RESULT=$(echo | awk -v R="$RESULT" -v E="$EXPECTED" -v T="$TOLERANCE" '
        BEGIN {
            # 入力文字列が数値でない場合（例えば空文字列の場合）は比較を失敗させる
            if (R ~ /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/ && E ~ /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/) {
                diff = (R > E) ? (R - E) : (E - R);
                if (diff <= T) print 1; else print 0;
            } else {
                print 0; # 数値でない場合は失敗
            }
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

# T7: ゼロ除算エラーテスト (終了コードとエラー出力を確認)
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
