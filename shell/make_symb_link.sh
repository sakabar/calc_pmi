#!/bin/zsh

if [ `hostname` != 'tsumire' ]; then
  echo "run at tsumire">&2
  exit 1
fi

lv pred.list.filtered | awk '{print $1}' | xargs -L1 -P1 -I% ln -s /local2/sasano/pa.data.basic.split/%.data.basic /local/tsakaki/pa.data.filtered/%

