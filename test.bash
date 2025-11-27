#!/bin/bash
LOG_CALC="./logarithmic_calculation"
PASSED=0
FAILED=0
# Pythonによる比較を使用するため、Bash側のTOLERANCEは不要
# TOLERANCE="0.000001" 

if [ ! -f "$LOG_CALC" ]; then
    echo "Error: Python script $LOG_CALC not found." >&2
    exit 1
fi

# Pythonで浮動小数点数を比較するヘルパー関数
# $1: Result, $2: Expected, $3: Tolerance
compare_float() {
    python3 -c "
import sys
try:
    result = float('$1')
    expected = float('$2')
    tolerance = 1e-6  # 許容誤差を固定 (0.000001)
    if abs(result - expected) <= tolerance:
        sys.exit(0) # 成功
    else:
        sys.exit(1) # 失敗
except ValueError:
    sys.exit(1) # どちらかが数値でない場合は失敗
"
    return $?
}


run_test() {
    TEST_NAME="$1"
    INPUT="$2"
    EXPECTED="$3"
    PRECISION="$4"

    # T7: ゼロ除算エラーテスト
    if [ "$TEST_NAME" == "T7_Error_DivByZero" ]; then
        # Python3 コマンドで実行し、標準出力は空、終了コードは非ゼロを期待
        RESULT=$(echo -n "$INPUT" | python3 "$LOG_CALC" 2>/dev/null)
        
        # 実行結果（$RESULT）が空文字列であり、かつ Python の実行が失敗しているか（$!=0）をチェック
        if [ -z "$RESULT" ] && [ $? -ne 0 ]; then
             echo "PASSED: $TEST_NAME (Error Handled)"
             PASSED=$((PASSED + 1))
        else
             echo "FAILED: $TEST_NAME (Expected error, but got: $RESULT)"
             FAILED=$((FAILED + 1))
        fi
        return
    fi
    
    # 正常系のテスト：結果を取得
    # 末尾の改行をパイプラインで確実に追加するために echo -n を使用
    RESULT=$(echo -n "$INPUT" | python3 "$LOG_CALC" -p "$PRECISION" 2>/dev/null)

    # Pythonヘルパー関数で比較を実行
    if compare_float "$RESULT" "$EXPECTED" 1e-6; then
        echo "PASSED: $TEST_NAME"
        PASSED=$((PASSED + 1))
    else
        echo "FAILED: $TEST_NAME"
        echo "     Input: $INPUT"
        echo "     Expected: $EXPECTED (Tolerance: 1e-6)"
        echo "     Got: $RESULT"
        FAILED=$((FAILED + 1))
    fi
}

echo "--- Starting Log Calculator Tests ---"
echo ""

# T1: 2.0 + 3.0 = 5.0
run_test "T1_Addition" "=,100,10\n+,8,2" "5.00000" 5

# T2: 3.0 - 2.0 = 1.0
run_test "T2_Subtraction" "=,1000,10\n-,100,10" "1.00000" 5

# T3: 2.0 * 2.0 = 4.0
run_test "T3_Multiplication" "=,100,10\n*,4,2" "4.00000" 5

# T4: 4.0 / 1.0 = 4.0
run_test "T4_Division" "=,16,2\n/,10,10" "4.00000" 5

# T5: (2.0 + 3.0) * 2.0 = 10.0
run_test "T5_MultiOp_Sequence" "=,100,10\n+,8,2\n*,100,10" "10.000" 3

# T6: 3.0
run_test "T6_Initial_Value" "=,1000,10" "3.00000" 5

# T7: ゼロ除算エラーテスト
run_test "T7_Error_DivByZero" "=,100,10\n/,1,10" "" 5 

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
