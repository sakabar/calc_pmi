#!/bin/zsh

lv ~/work/calc_pmi/pred.list \
  | LC_ALL=C grep -v ":判" \
  | LC_ALL=C grep -v "\+" \
  | grep -v "[０-９]" \
  | grep -v "[Ａ-Ｚ]" | grep -v "[ａ-ｚ]"
  
  # | LC_ALL=C grep -v "られる/られる" \
  # | LC_ALL=C grep -v "せる/せる" \
  # | LC_ALL=C grep -v "させる/させる" \
  # | LC_ALL=C grep -v "\+欲しい/ほしい" 


# > ~/work/calc_pmi/p


