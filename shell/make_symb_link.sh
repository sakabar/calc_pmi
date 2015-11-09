#!/bin/zsh

#source_dir内のファイルから、pred.list.filteredに含まれるファイルのみを抽出し、$target_dirにシンボリックリンクを張る
#シンボリックリンクを張るだけので、$source_dirの中身は残しておくこと!

source_dir=/local/tsakaki/pa.count.all

if [ ! -e $source_dir ]; then
  echo "run at another server (e.g. tsumire)">&2
  exit 1
fi

target_dir=/local/tsakaki/pa.count.filtered
if [ ! -e $target_dir ]; then
  mkdir -p $target_dir
fi

rm -rf $target_dir/*
lv pred.list.filtered | awk '{print $1}' | xargs -L1 -P1 -I% ln -s $source_dir/% $target_dir/%
