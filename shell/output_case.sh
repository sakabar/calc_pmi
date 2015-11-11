#!/bin/bash

#生の文字列を標準入力から受け取り、格の情報を出力する
cat - | juman | knp -dpnd-fast -check -tab \
  | nkf -e | tac | ~sasano/cvs/cf/scripts/feature2bnst.perl | tac \
  | perl -I/home/lr/sasano/cvs/kawahara-pm/perl ~sasano/cvs/cf/scripts/make-caseframe.perl -rn -c 1 \
  | nkf -w
