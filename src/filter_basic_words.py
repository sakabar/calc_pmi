#coding:utf-8
import sys
import re

#web15G-201306-003692 ＣＭＳ/ＣＭＳ+化/か+する/する+たい/たい:動
#のような行を受け取り、Juman辞書に載っていない形態素を含む行を除去する
#すなわち、「読み」の部分がひらがなでないような形態素を含む行を除去する

def main():
    pat0 = re.compile(r':[^:]+$')
    pat1 = re.compile(r'[+?]')

    #http://winter-tail.sakura.ne.jp/pukiwiki/index.php?Python%A4%A2%A4%EC%A4%B3%A4%EC%2F%C0%B5%B5%AC%C9%BD%B8%BD%A5%D1%A5%BF%A1%BC%A5%F3#a6655ac9
    all_hiragana_regexp = re.compile(r'^(?:\xE3\x81[\x81-\xBF]|\xE3\x82[\x80-\x93])+$')

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split(' ')
        filename = lst[0]
        mrphs_str = lst[1]

        #「:動」のような部分を除去
        mrphs_str = pat0.sub('', mrphs_str)
        mrphs_lst = pat1.split(mrphs_str)

        yomi_lst = [mrph.split('/')[1] for mrph in mrphs_lst if len(mrph.split('/')) == 2]
        if len(yomi_lst) != len(mrphs_lst):
            #読みがない形態素があったら、その行は飛ばして次の述語へ
            # sys.stderr.write("no-yomi\n")
            continue

        if all([all_hiragana_regexp.search(yomi) for yomi in yomi_lst]):
            #もし、全ての「読み」がひらがななら、その行を出力
            print line
        else:
            pass
    

if __name__ == '__main__':
    main()


