#!/usr/bin/env bash

function count_occurences() {
    local needle=$1
    shift
    local haystack=( $@ )
    counter=0
    for i in "${haystack[@]}"
    do
        if (( i == needle )); then
            counter=$(( counter + 1 ))
        fi
    done
    echo "$counter"
}


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

SCORE=0
for i in "${DATA_A[@]}"
do
    # echo "Needle : $i"
    occurences=$(count_occurences $i "${DATA_B[@]}")
    # echo "Occurences : $occurences"
    SCORE=$(( SCORE + (occurences * i) ))
done

echo $SCORE
