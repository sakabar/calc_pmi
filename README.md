# calc_pmi
calculate PMI of a pred and a argument.


格フレームのコーパスから、項の動詞のPMIを計算する
データは秘密。

【/shell】
calc_pmi_arg_all_verbs.sh : ある項を引数として、指定したディレクトリ内の全ての動詞に対してPMIを計算し、出力する
calc_pmi_arg_verb.sh : ある項を引数として、標準入力から受け取った共起回数のデータに基づき、ある動詞に関するPMIを計算し、出力する
count_pred_of_arg.sh : src/count_arg_of_pred.pyを、forループで回す
exe.sh :
exe_all.sh :
merge_count.sh count_arg_of_pred.pyで出力したファイル群の回数をマージする
output_case.sh : 生の文字列を標準入力から受け取り、格の情報を出力する

【/src】

src/count_arg_of_pred.py : ある動詞について、その動詞とある項が共起する回数が収められたファイル(/path/to/pa.data.basic.split/web15G-201306-237739.data.basicなど)を標準入力から読み込み、その動詞の回数の和と(1行目)と、項ごとの回数を出力する

`lv /path/to/pa.data.basic.split/web15G-201306-237739.data.basic | python src/count_arg_of_pred.py > web15G-201306-237739.data.basic.count`

output_just_prev_case.py : 

メモ
まず、pred.list.filteredを作成
次に、count_pred_of_arg.shで回数をカウント
そして、merge_count.shで回数をマージ
まず、pred.list.filtered.count.split/00-26を作成
いよいよ exe_all.sh
