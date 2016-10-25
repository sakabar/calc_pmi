#!/bin/zsh

set -eu

zmodload -i zsh/mathfunc #zshの数学関数を読み込む

#述語を引数として、全ての(名詞と格のペア)に対するPMIを出力する
if [ $# -ne 1 ]; then
  echo "1 argument is required">&2
  exit 1
fi

pred=$1


merged_count_file=/local/tsakaki/merged_count_of_arg.txt

# 例: 'web15G-201306-102320 撃つ/うつ:動'
# pred='撃つ/うつ:動'
arg_count_dir=/local/tsakaki/pa.count.all
verb_count_file=$arg_count_dir/`cat ~/work/calc_pmi/pred.list | grep " "$pred"$" | awk '{print $1}' `

# verb_count_file=$arg_count_dir/'web15G-201306-102320'

all_sum_count=`LC_ALL=C grep " SUM$" $merged_count_file | awk '{print $1}'`
sum_count_of_verb=`LC_ALL=C grep " SUM " $verb_count_file | awk '{print $1}'`

cat $verb_count_file | tail -n+2 |
while read line; do
  count_arg_given_verb=`echo $line | awk '{print $1}'`
  arg=`echo $line | awk '{print $2}'`
  count_arg_in_all_verbs=`LC_ALL=C grep " "$arg"$" $merged_count_file | awk '{print $1}'`
  # count_arg_given_verb=`LC_ALL=C grep " $arg " $verb_count_file | awk '{print $1}'`


  #もしも(何故か)count_arg_in_all_verbsが空文字列の場合は、終了
  if [ -z $count_arg_in_all_verbs ]; then
    echo "$pred"
    exit 0
  fi

# echo "$pred">&2 
# echo "sum_all:"$all_sum_count >&2
# echo "sum_v  :"$sum_count_of_verb >&2
# echo "cnt_v  :"$count_arg_given_verb >&2
# echo "cnt_all:"$count_arg_in_all_verbs >&2


pmi=$[ log($count_arg_given_verb) - log($sum_count_of_verb) + log($all_sum_count) - log($count_arg_in_all_verbs) ]
echo "$pmi $count_arg_given_verb $sum_count_of_verb $all_sum_count $count_arg_in_all_verbs $arg $pred"

done
