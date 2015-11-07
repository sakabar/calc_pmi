#!/bin/zsh

set -ue
prev_case_file=just_prev_case.txt
output_dir=/home/lr/tsakaki/work/calc_pmi

#FIXME ベタ打ち
lv ~/work/replace_with_antonym/data/input_uniq.knp \
  | python src/output_just_prev_case.py > $prev_case_file

line=""

# 自分/じぶん:ニ格 負ける/まける:動
cat -n $prev_case_file \
  | while read line; do
  sid=`echo $line | awk '{print $1}'`
  arg=`echo $line | awk '{print $2}'`
  pred=`echo $line | awk '{print $3}'`

  echo $sid >&2
  if [ $arg = "NONE" ]; then
      touch $output_dir/$sid.txt
  else
    ./shell/exe.sh $arg > $output_dir/$sid.txt
  fi
done
