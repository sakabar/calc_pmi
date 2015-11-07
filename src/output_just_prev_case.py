#coding:utf-8
import sys
import re

regex0 = re.compile('<格解析結果:([^:]+:[^:0-9]+)[0-9]*:([^>]+)>')
regex1 = re.compile('<係:([^>]+)>')
regex2 = re.compile('<正規化代表表記:([^>]+)>')

def sentence_func(knp_lines):
    last_basic_phrase=[line for line in knp_lines if line[0] == '+'][-1]

    m0 = regex0.search(last_basic_phrase)
    if m0:
        pred = m0.group(1)
        cases = m0.group(2).split(';')

        bp_nums = [int(case.split('/')[3]) for case in cases if case.split('/')[3] != '-']
        if len(bp_nums) != 0:
            bp_num = max(bp_nums)
            bp = [line for line in knp_lines if line.startswith("+ %d " % bp_num)][0]

            #bpの正規化代表表記を取って、格と足す
            #<係:マデ>とか
            #KNPの格解析結果をどこまで信じるか…?
            #解析格を利用しないことにした。
            
            case = ""
            norm_form = ""
            m1 = regex1.search(bp)
            m2 = regex2.search(bp)

            if m1 and m2:
                case = m1.group(1)
                norm_form = m2.group(1)
                print "%s:%s %s" % (norm_form, case, pred)
            else:
                print "NONE 0"# % pred

        else:
            print "NONE 1"# % pred

    else:
        print "NONE 2"# % pred

    return
    

def main():
    knp_lines = []

    for line in sys.stdin:
        line = line.rstrip()

        if line == "EOS":
            sentence_func(knp_lines)
            knp_lines = []
        else:
            knp_lines.append(line)

    return

if __name__ == '__main__':
    main()
