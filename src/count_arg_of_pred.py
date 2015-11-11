#coding:utf-8
import sys
import re

#ある動詞について、その動詞とある項が共起する回数が収められたファイル(/path/to/pa.data.basic.split/web15G-201306-237739.data.basicなど)を標準入力から読み込み、その動詞の回数の和と(1行目)と、項ごとの回数を出力する

def main():
    category_NER_info_regex = ';[nc][^:;]+' #項に付属しているカテゴリ情報・固有表現解析情報

    cnt_dict = {} #項とその回数を記憶する辞書
    sum_cnt = 0 #合計を記憶する。これは、cnt_dictに収められた回数の合計とは【一致しない】ので注意。
    pred = "" #読み込むファイルが対象としている動詞

    for line in sys.stdin:
        line = line.strip() #文字列の左詰めの空白、および右の改行を除去
        lst = line.split(' ')
        cnt = int(lst[0])
        pred = lst[1]
        args = lst[2:] #argsは1個以上
        sum_cnt += cnt #これは、直前格を持たない場合も足す。こうすると、後に求める確率を「ある動詞が出現した時に、hogeという格を直前格に持つ確率」と言うことができる。もし直前格の回数だけを足してしまうと、「ある動詞が出現して、かつ直前格を持っていたときに、hogeという格を直前格に持つ確率」を求めることになる。
        
        for arg in args:
            #もしargが直前格ならば
            if ('*' in arg):
                arg = arg.replace('*', '') #直前格であるというマークを除去
                arg = arg.replace('%', '') #複合名詞であるというマークを除去
                arg = re.sub(category_NER_info_regex, '', arg) #カテゴリ・NER情報を除去
             
                if arg in cnt_dict:
                    cnt_dict[arg] += cnt
                else:
                    cnt_dict[arg] = cnt


    print "%d %s %s" % (sum_cnt, "SUM", pred)
    for arg_key in cnt_dict:
        print "%d %s %s" % (cnt_dict[arg_key], arg_key, pred)

    return

if __name__ == '__main__':
    main()
