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
  arg_word=`echo $arg | awk -F: '{print $1}'`
  arg_case=`echo $arg | awk -F: '{print $2}'`
  pred=`echo $line | awk '{print $3}'`

  #fflushはシェルのコマンドには無い…?
  echo "$sid @ exe_all.sh "`date` | awk '{print $0}{fflush()}' >&2
  if [ $arg = "NONE" ]; then
    touch $output_dir/$sid"_none_none.txt"
  else
    ./shell/exe.sh $arg | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8" False"}' > $output_dir/$sid"_"$arg_case"_"$arg_case".txt"
    
    #格変化させる: ヲ→ニ ニ→ヲ ニ→カラ カラ→ニ
    case "$arg_case" in 
      'ヲ格' ) ./shell/exe.sh $arg_word:'ニ格' | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8" ヲ_ニ"}' > $output_dir/$sid"_ヲ格_ニ格.txt" ;;
      'ニ格' ) ./shell/exe.sh $arg_word:'ヲ格' | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8" ニ_ヲ"}' > $output_dir/$sid"_ニ格_ヲ格.txt"
               ./shell/exe.sh $arg_word:'カラ格' | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8" ニ_カラ"}' > $output_dir/$sid"_ニ格_カラ格.txt" ;;
      'カラ格' ) ./shell/exe.sh $arg_word:'ニ格' | awk -v pred=$pred '{print $1" "$2" "$3" "$4" "$5" "pred" "$6" "$7" "$8" カラ_ニ"}' > $output_dir/$sid"_カラ格_ニ格.txt" ;;
    esac
  fi
done
