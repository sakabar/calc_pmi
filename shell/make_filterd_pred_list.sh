#!/bin/zsh

lv /local2/sasano/pred.list \
  | LC_ALL=C grep -v ":判" \
  | LC_ALL=C grep -v "れる/れる" \
  | LC_ALL=C grep -v "られる/られる" \
  | LC_ALL=C grep -v "せる/せる" \
  | LC_ALL=C grep -v "させる/させる" \
  | LC_ALL=C grep -v "\+欲しい/ほしい" 


# > ~/work/calc_pmi/p


