#!/bin/zsh

set -ue

# まず、pred.list.filteredを作成
# 次に、count_pred_of_arg.shで回数をカウント
# そして、merge_count.shで回数をマージ
# まず、pred.list.filtered.count.split/00-26を作成
# そのあと、いよいよ exe_all.sh


#まず、26万の全てのファイルに対して、「項ごとの頻度」を出力する
# ./shell/count_pred_of_arg.sh

#次に、使う述語のリストを出力する
# ./shell/make_filtered_pred_list.sh | python src/filter_basic_words.py > pred.list.filtered

#使う述語のリストのみ、シンボリックリンクを張って抽出
./shell/make_symb_link.sh

#使う述語全てのカウントをマージ
#2万ファイルに関して、5分くらい
./shell/merge_count.sh

#出力用ディレクトリを作成し、適当に分割する
source_dir=/local/tsakaki/pa.count.filtered
target_dir=$source_dir".split"
split_num=27 #(00 .. $split_num-1) まで、$split_num個のディレクトリを作成
rm -rf $target_dir
mkdir -p $target_dir

file_num=`ls $source_dir | wc -l` #$source_dir内のファイル数
head_num=$[ $file_num / ($split_num - 1) ]

#次に、$source_dirから$target_dir/00 .. $target_dir/$split_num-1 にシンボリックリンクを張る
for i in {00..$[$split_num - 1]}; do
  mkdir -p $target_dir/$i
  ls $source_dir \
    | awk -v i="$i" -v head_num="$head_num" \
      '(i * head_num + 1) <= NR && NR <= ((i+1)* head_num) {print $0}' \
    | xargs -L1 -P1 -I% ln -s $source_dir/% $target_dir/$i/
done
