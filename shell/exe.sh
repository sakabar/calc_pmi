#!/bin/zsh

set -eu

#項を引数として、全ての動詞に対するPMIを出力する
if [ $# -ne 1 ]; then
  echo "1 argument is required">&2
  exit 1
fi

# arg_count_dir='/local/tsakaki/pa.data.basic.split.count' #count_pred_of_arg.shの出力先

merged_count_file=/local/tsakaki/merged_count_of_arg.txt
output_dir=/local/tsakaki/pa.data.result

arg=$1

vocab_num=$[`wc -l $merged_count_file | awk '{print $1}'` - 1] #24321355
all_sum_count=`LC_ALL=C grep " SUM$" $merged_count_file | awk '{print $1}'`
count_arg_in_all_verbs=`LC_ALL=C grep " "$arg"$" $merged_count_file | awk '{print $1}'`

para_num=10 #並列数

#出力先ファイルの初期化
for i in {0..26}; do
  cat /dev/null > $output_dir/$i".txt"
done

#para_numの数だけ並列実行を行う。
#すごく読みにくい…
for i in {0..$[26 / $para_num]}; do
  begin_num=$[$para_num * $i]
  end_num=0
  t=$[$para_num * ($i + 1) -1]
  if [ $t -gt 26 ]; then #FIXME magic num
    end_num=26
  else
    end_num=$t
  fi

  #ここで並列実行
  for j in {$begin_num..$end_num}; do
    num=`printf "%02d" $j`
    echo $num"/26 @ exe.sh">&2
    d=/local/tsakaki/pa.data.basic.split.count.split/pa.data.basic.split.count.$num

    ( ./shell/calc_pmi_arg_all_verbs.sh $arg $d $vocab_num $all_sum_count $count_arg_in_all_verbs > $output_dir/$num".txt" ) &
  done

  #&のバックグラウンド実行の終了を待つ
  wait

done


#後始末
nbest_num=20 #PMIの上位何件を取るか?

#全体のnベストに入るためには、分割したファイルそれぞれで
#nベストに入っている必要があることを利用する
for i in {00..26}; do
  LC_ALL=C sort -nr $output_dir/$i.txt | head -n $nbest_num
done | LC_ALL=C sort -nr | head -n $nbest_num
