#!/bin/bash
d=/local/tsakaki/pa.data.basic.split.count
output=/local/tsakaki/merged_count_of_arg.txt

#ファイル数が多すぎるため、xargsを使う
ls $d | xargs -L1 -P1 cat \
  | awk '{a[$2]+=$1} END{for(k in a) {print a[k]" "k}}' \
  > $output
