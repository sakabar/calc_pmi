#!/bin/zsh

set -ue

if [ $# -ne 3 ]; then
  echo "Argument num error">&2
  exit 1
fi

freq=$1
nbest=$2
gold_file=$3

s_id=1
cat $gold_file | 
while read gold_line; do
  # echo $gold_line
  result_file='/home/lr/tsakaki/work/calc_pmi/result/'`printf "%03d" $s_id`".txt"

  colmun_num=`cat $result_file | head -n1 | awk '{print NF}'`
  # echo $cnum
  if [ $colmun_num -lt 8 ]; then
    echo "skip">&2
  else
    cat $result_file | awk -v freq=$freq '$2 >= freq {print $0}' | head -n $nbest | python src/eval.py $s_id $gold_line | uniq 
  fi

  s_id=$[$s_id + 1]
done > eval_result/`printf "%04d" $freq`"_freq_"`printf "%03d" $nbest`"_nbest.txt"
