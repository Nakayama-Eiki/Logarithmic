#!/bin/bash -x

ng () {
    echo "${1}行目が違うよ: 想定と異なる結果が出力されました"
    res=1
}

res=0
SCRIPT="./logarithmic_calculation"

EXPECTED="  10.00 | 1.000000 | 00000000000000000000"
out=$(echo 10 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

EXPECTED="   1.00 | 0.000000 | "
out=$(echo 1 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

EXPECTED="1000.00 | 3.000000 | 000000000000000000000000000000000000000000000000000000000000"
out=$(echo 1000 | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED" ] || ng "$LINENO"

EXPECTED_MULTI=$(cat <<EOF
   2.00 | 0.301030 | 000000
 100.00 | 2.000000 | 0000000000000000000000000000000000000000
   5.00 | 0.698970 | 0000000000000
EOF
)
out=$(printf "2\n100\n5\n" | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "$EXPECTED_MULTI" ] || ng "$LINENO"

out=$(echo 0.5 | "$SCRIPT")
[ "$?" -eq 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo -5 | "$SCRIPT")
[ "$?" -eq 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo "abc" | "$SCRIPT")
[ "$?" -eq 1 ] || ng "$LINENO" 
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo "" | "$SCRIPT")
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$("$SCRIPT" < /dev/null)
[ "$?" -eq 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

if [ "${res}" -eq 0 ]; then
    echo "OK"
else
    echo "NG"
fi

exit "$res"
