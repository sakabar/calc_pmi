#!/bin/zsh

set -ue

if [ $# -ne 1 ];then
  echo "One argument is required">&2
  exit 1
fi

prev_case_file=$1
# prev_case_file=just_prev_case.txt
# #FIXME ベタ打ち
# lv ~/work/replace_with_antonym/data/input_uniq.knp \
#   | python src/output_just_prev_case.py > $prev_case_file


output_dir=/home/lr/tsakaki/work/calc_pmi/result
touch $output_dir/a.txt #ダミーファイルを作らないと、$output_dirが空だったときにエラーで止まる(set -eu)
rm -rf $output_dir/*

#$prev_case_fileには、
#自分/じぶん:ニ格 負ける/まける:動
#のような行が格納されている
cat -n $prev_case_file \
  | while read line; do
  sid=`echo $line | awk '{printf("%03d",$1)}'`
  arg=`echo $line | awk '{print $2}'`
  pred=`echo $line | awk '{print $3}'`

  #fflushはシェルのコマンドには無い…?
  echo "$sid @ exe_all.sh "`date` | awk '{print $0}{fflush()}' >&2
  if [ $arg = "NONE" ]; then
    touch $output_dir/$sid.txt
  else
    ./shell/exe.sh $arg | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8}' > $output_dir/$sid.txt
  fi
done
