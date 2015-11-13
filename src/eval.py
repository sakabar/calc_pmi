#coding:utf-8

import sys

def main(s_id, gold_line):
    gold_line_lst = gold_line.split(' ')
    gold_answers = gold_line_lst[4:]
    dict_answer = gold_line_lst[2]

    for result_line in sys.stdin:
        result_line = result_line.rstrip()
        result_lst = result_line.split(' ')

        if(len(set(result_lst)) < 8):
            break

        result_pred = result_lst[7]

        if result_pred in gold_answers:
            dic_bool = result_pred == dict_answer
            print "%d %s %s" % (s_id, dic_bool, result_pred)

    return

if __name__ == '__main__':
    argv = sys.argv
    argc = len(argv)
    if argc != 3:
        sys.stderr.write("Error in eval.py\n")
    
    s_id = int(argv[1])
    gold_line = argv[2]
    main(s_id, gold_line)
