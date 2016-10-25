#!/bin/zsh
#

set -u

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
  s_id_str=`printf "%03d" $s_id`
  gold_case=`echo $gold_line | awk '{print $4}'`
  for result_file in `ls '/home/lr/tsakaki/work/calc_pmi/result/'$s_id_str"_"*.txt`; do
    echo "$result_file:t" | grep "_"$gold_case"\.txt" >/dev/null #格が一致しているか?
    if [ $? -eq 0 ]; then
      colmun_num=`cat $result_file | head -n1 | awk '{print NF}'`
      if [ $colmun_num -lt 8 ]; then
        # echo "skip">&2
      else
        cat $result_file | awk -v freq=$freq '$2 >= freq {print $0}' | head -n $nbest | python src/eval.py $s_id $gold_line | awk -v f=$result_file '{print $0" "f}'
      fi
    fi

  done

  s_id=$[$s_id + 1]
done > eval_result/`printf "%04d" $freq`"_freq_"`printf "%03d" $nbest`"_nbest.txt"
