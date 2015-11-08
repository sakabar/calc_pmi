#coding:utf-8
import sys
import re

#web15G-201306-003692 ＣＭＳ/ＣＭＳ+化/か+する/する+たい/たい:動
#のような行を受け取り、Juman辞書に載っていない形態素を含む行を除去する
#すなわち、「読み」の部分がひらがなでないような形態素を含む行を除去する


#http://furodrive.com/2014/04/zenhan/
def is_hiragana(s):
    a =   [ch for ch in s if "あ" <= ch <= "ん"]
    if len(s) == len(a):
        return True
    return False
 
def main():
    pat0 = re.compile(r':[^:]+$')
    pat1 = re.compile(r'[+?]')
    

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split(' ')
        filename = lst[0]
        mrphs_str = lst[1]

        #「:動」のような部分を除去
        mrphs_str = pat0.sub('', mrphs_str)
        mrphs_lst = pat1.split(mrphs_str)

        yomi_lst = [mrph.split('/') for mrph in mrphs_lst if len(mrph.split('/')) == 2]
        if len(yomi_lst) != len(mrphs_lst):
            #読みがない形態素があったら、その行は飛ばして次の述語へ
            continue

        if all([is_hiragana(yomi) for yomi in yomi_lst]):
            #もし、全ての「読み」がひらがななら、その行を出力
            print line
        else:
            pass
    

if __name__ == '__main__':
    main()


