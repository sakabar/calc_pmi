# calc_pmi
calculate PMI of a pred and a argument.


格フレームのコーパスから、項の動詞のPMIを計算する
データは秘密。

src/count_arg_of_pred.py : ある動詞について、その動詞とある項が共起する回数が収められたファイル(/path/to/pa.data.basic.split/web15G-201306-237739.data.basicなど)を標準入力から読み込み、その動詞の回数の和と(1行目)と、項ごとの回数を出力する

`lv /path/to/pa.data.basic.split/web15G-201306-237739.data.basic | python src/count_arg_of_pred.py > web15G-201306-237739.data.basic.count`

shell/count_pred_of_arg.sh : src/count_arg_of_pred.pyを、forループで回す

shell/output_case.sh : 生の文字列を標準入力から受け取り、格の情報を出力する
