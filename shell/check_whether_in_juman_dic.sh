#!/bin/zsh

# JumanのContentW.dicを引き、存在する単語のみを使う
# 複合語に注意!

while read line; do
  file=`echo $line | awk '{print $1}'`
  word=`echo $line | awk '{print $2}' | sed -e 's/:.*$//' | sed -e 's|+する/する||' | sed -e 's|/.*||'`
  grep $word ~/local/src/juman-7.01/dic/ContentW.dic | grep -E "動詞|形容詞" > /dev/null
  is_in_dic=$?
  if [ $is_in_dic -eq 0 ]; then
    #ok
    echo $line
  else
    # echo $word" is out of dic"
  fi
  # echo $file
  # echo $word
done
