#!/bin/bash -x
#

ng () {
        echo "${1}行目が違うよ: 想定と異なる結果が出力されました"
        res=1
}

res=0 # 全体結果 (0=OK, 1=NG)
SCRIPT="./logarithmic_calculation"

# --- 1. 正常系のテスト (n > 1.0) ---
##1-1
# log10(10) = 1.0
# length = int(1.0 * 20) = 20
EXPECTED="  10.00 | 1.000000 | 00000000000000000000"
out=$(echo 10 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

##1-2
# log10(1) = 0.0
# length = int(0.0 * 20) = 0
EXPECTED="   1.00 | 0.000000 | "
out=$(echo 1 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

##1-3
# log10(1000) = 3.0
# length = int(3.0 * 20) = 60
EXPECTED="1000.00 | 3.000000 | 000000000000000000000000000000000000000000000000000000000000"
out=$(echo 1000 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

##1-4
EXPECTED_MULTI=$(cat <<EOF
   2.00 | 0.301030 | 000000
 100.00 | 2.000000 | 0000000000000000000000000000000000000000
   5.00 | 0.698970 | 0000000000000
EOF
)
out=$(echo -e "2\n100\n5" | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED_MULTI" ] || ng "$LINENO"

#--- 2. 境界値・例外系のテスト ---
##2-1
out=$(echo 0.5 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

##2-2
out=$(echo -5 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

##2-3
out=$(echo "abc" | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO" 
[ "${out}" = "" ] || ng "$LINENO"

##2-4
out=$(echo "" | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

##2-5
out=$("$SCRIPT" < /dev/null)
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"


# --- final_result ---
if [ "${res}" -eq 0 ]; then
    echo "OK"
else
    echo "NG"
fi

exit "$res"
