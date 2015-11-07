#!/bin/zsh

#項と回数ファイルを引数として、ある項と動詞のPMIを出力する

set -ue

zmodload -i zsh/mathfunc #zshの数学関数を読み込む

if [ $# -ne 5 ]; then
  echo "5 arguments are required in calc_pmi_arg_verb.sh" >&2
  exit 1
fi

arg=$1
verb_count_file=$2
vocab_num=$3 #$merged_count_fileの行数-1(SUMの行のぶん)だが、forでしたときに毎回計算するのはムダなので、上層で計算して引数として渡す
all_sum_count=$4 #all_sum_countも同様に、引数として渡す
count_arg_in_all_verbs=$5 #同様に、引数

merged_count_file=/local/tsakaki/merged_count_of_arg.txt

sum_count_of_verb=`LC_ALL=C grep " SUM " $verb_count_file | awk '{print $1}'`
count_arg_given_verb=`LC_ALL=C grep " $arg " $verb_count_file | awk '{print $1}'`

pred=`head -n1 $verb_count_file | awk '{print $3}'`

# echo "sum_all:"$all_sum_count
# echo "sum_v  :"$sum_count_of_verb
# echo "cnt_v  :"$count_arg_given_verb
# echo "cnt_all:"$count_arg_in_all_verbs


#スムージングする。
log_pmi=$[ log10($count_arg_given_verb + 1.0) - log10($sum_count_of_verb + $vocab_num) - log10($count_arg_in_all_verbs + 1.0) + log10($all_sum_count + $vocab_num) ]
echo "$log_pmi $arg $pred $verb_count_file"
