#coding:utf-8
import math
import sys
import more_itertools

def get_merged_count_of_arg():
    path = '/local/tsakaki'
    ans_dic = {}

    merged_file = 'merged_count_of_arg_all.txt'
    with open(path + '/' + merged_file) as mf:
        for line in mf:
            line = line.rstrip()
            lst = line.split(' ')
            cnt = int(lst[0])
            arg = lst[1]

            if arg in ans_dic:
                raise Exception('key conflict')
            else:
                ans_dic[arg]=cnt

    return ans_dic
        
def get_pred_dic():
    path = '/home/lr/tsakaki/work/calc_pmi'
    ans_dic = {}

    with open(path + '/pred.list') as pl:
        for line in pl:
            line = line.rstrip()
            lst = line.split(' ')
            fname = lst[0]
            arg = lst[1]

            if arg in ans_dic:
                raise Exception('key conflict')
            else:
                ans_dic[arg]=fname

    return ans_dic
        


def main():
    merged_count_of_arg_dic = get_merged_count_of_arg()
    sum_all = merged_count_of_arg_dic["SUM"]

    pred_file_name_dic = get_pred_dic()
    pred_file_dir = '/local/tsakaki/pa.count.all'

    #標準入力から、禁止されている述語と、その直前格を読み込む
    #古傷/ふるきず:ヲ格 抉る/えぐる:動
    for ban_arg_pred_line in sys.stdin:
        ban_arg_pred_line = ban_arg_pred_line.rstrip()
        lst = ban_arg_pred_line.split(' ')
        input_arg = lst[0]
        input_arg_case = input_arg.split(':')[1]
        pred = lst[1]

        pred_file_name = pred_file_name_dic[pred]
        sum_v = -1

        #中身は
        #373755 SUM 撃つ/うつ:動
        with open(pred_file_dir + '/' + pred_file_name) as pred_file:
            ans_log_PMI_dict = {} #argをキーとして、(log_pmi, (count_arg_given_pred, sum_v, sum_all, count_arg))を値とする辞書

            for count_pred_line in pred_file:
                count_pred_line = count_pred_line.rstrip()
                count_pred_lst = count_pred_line.split(' ')
                count_arg_given_pred = int(count_pred_lst[0])
                arg = count_pred_lst[1]
                # pred = count_pred_lst[2] #既に代入したpredと同じ

                if arg == "SUM": #pred_fileの一行目には"SUM"が入っているという前提
                    sum_v = count_arg_given_pred
                elif arg.split(':')[1] == input_arg_case: #入力した項と同じ格のみ対象とする
                    try:
                        log_PMI = math.log10(count_arg_given_pred) - math.log10(sum_v) + math.log10(sum_all) - math.log10(merged_count_of_arg_dic[arg])
                    except:
                        raise Exception("%s %s %s" % (arg, pred, pred_file_name))
                    ans_log_PMI_dict[arg] = (log_PMI, (count_arg_given_pred, sum_v, sum_all, merged_count_of_arg_dic[arg]))

                    # print "count_arg_given_pred: %d" % count_arg_given_pred
                    # print "sum_v: %d" % sum_v
                    # print "sum_all: %d" % sum_all
                    # print "count_arg: %d" % merged_count_of_arg_dic[arg]


            #ans_log_PMI_dictをソートして出力
            #lambdaの部分がややこしい。items()メソッドで(key, value)のタプルを作って、x[1]でvalueを取り、そのvalue(タプル)の0番目であるPMIをとって、これをキーとしてソートする

            take_num = 1000 #20
            freq_th = 100 #頻度がこれ以上の(項, 述語)ペアのみを対象とする
            ans_items = [(k,v) for k, v in ans_log_PMI_dict.items() if v[1][0] >= freq_th]
            ranked = sorted(ans_items, key=lambda x:x[1][0], reverse=True)
            ranked = more_itertools.take(take_num, ranked)
            for k_arg, v_tpl in ranked:
                log_PMI = v_tpl[0]
                count_tpl = v_tpl[1]

                print "%f %d %d %d %d %s %s" % (log_PMI, count_tpl[0], count_tpl[1], count_tpl[2], count_tpl[3], k_arg, pred)
                
            #break #FIXME. これはstdinのforループ
        

if __name__ == '__main__':
    main()
