#coding:utf-8

#calc_pmi_of_for_all_args.pyの出力結果から、JumanのContentW.dicに収められている単語のみを抜き出して出力する

import sys

def main():
    juman_dic = {}
    d = '/home/lr/tsakaki/work/calc_pmi'
    with open(d + '/' + 'juman_noun_in_contentW.txt') as noun_f:
        for line in noun_f:
            line = line.rstrip()
            juman_dic[line] = 1

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split(' ')
        if lst[5].split(':')[0] in juman_dic:
            print line
            
if __name__ == '__main__':
    main()
