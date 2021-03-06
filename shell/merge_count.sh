#!/bin/bash

#$source_dirにある述語ファイル全てに含まれる情報をマージする

if [ $# -ne 1 ];then
  echo "one argument is required" >&2
  exit 1
fi

source_dir=$1
# source_dir=/local/tsakaki/pa.count.filtered
# output_file=/local/tsakaki/merged_count_of_arg.txt

#ファイル数が多すぎるため、xargsを使う
ls $source_dir | xargs -L1 -P1 -I% cat $source_dir/% \
  | awk '{a[$2]+=$1} END{for(k in a) {print a[k]" "k}}' 
  # > $output_file
