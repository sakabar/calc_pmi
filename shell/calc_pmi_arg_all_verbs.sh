#!/bin/zsh

#項とディレクトリを引数として、ディレクトリ内の全ての動詞に対するPMIを出力する
if [ $# -ne 5 ]; then
  echo "5 arguments are required in calc_pmi_arg_all_verbs.sh">&2
  exit 1
fi

arg_count_dir='/local/tsakaki/pa.data.basic.split.count' #count_pred_of_arg.shの出力先

merged_count_file=/local/tsakaki/merged_count_of_arg.txt

arg=$1
d=$2
vocab_num=$3
all_sum_count=$4
count_arg_in_all_verbs=$5

for f in $d/*; do
  ./shell/calc_pmi_arg_verb.sh $arg $f $vocab_num $all_sum_count $count_arg_in_all_verbs
done
