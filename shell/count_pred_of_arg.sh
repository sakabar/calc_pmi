#!/bin/zsh

set -ue

#$input_dirに置いてあるファイルそれぞれに対してsrc/count_arg_of_pred.pyを実行し、
#結果を$output_dir内に格納する

if [ `hostname` != 'tsumire' ]; then
    echo "run in server 'tsumire'">&2 #tsumireにデータが置いてある。ここ今はベタ打ち。
    exit 1
fi

input_dir=/local2/sasano/pa.data.basic.split #sasanoさんが持っている、加工していない、元々のデータが入っているディレクトリ
output_dir=/local/tsakaki/pa.count.all

if [ ! -e $output_dir ]; then
  mkdir -p $output_dir
fi

file_cnt=0
max_cnt=`ls $input_dir | wc -l`
for f in $input_dir/*; do
# for f in `ls $input_dir | tail -n 100`; do
    file_cnt=$(( file_cnt + 1 ))
    echo "$file_cnt / $max_cnt">&2
    lv $input_dir/$f:t | python src/count_arg_of_pred.py > $output_dir/$f:t:r:r
done
