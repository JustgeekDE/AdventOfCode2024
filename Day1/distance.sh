#!/usr/bin/env bash

INPUT_FILE=${1:-"input.txt"}

if [ ! -f "${INPUT_FILE}" ]; then
    echo "File ${INPUT_FILE} no found"
    exit 1
fi


DATA_A=( )
DATA_B=( )

while read input_line; do
    input_array=( $input_line )
    a=${input_array[0]}
    b=${input_array[1]}
    DATA_A+=($a)
    DATA_B+=($b)
done <"${INPUT_FILE}"


SORTED_A=$(printf '%s\n' "${DATA_A[@]}" | sort)
SORTED_B=$(printf '%s\n' "${DATA_B[@]}" | sort)
LINES_A=$(echo $SORTED_A | wc -w)

ARRAY_A=( $SORTED_A )
ARRAY_B=( $SORTED_B )

echo "Lines: ${LINES_A}"
SUM=0
for i in `seq 1 $LINES_A`; do
    a=${ARRAY_A[i-1]}
    b=${ARRAY_B[i-1]}
    if (( a > b )); then
        SUM=$((SUM + (a-b)))
    else 
        SUM=$((SUM + (b-a)))
    fi
done
echo $SUM
