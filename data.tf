//外からデータを取り出していく時に仕様する

#プレフィックスリストを定義
data "aws_prefix_list" "s3_pl" {

  #  プレフィックスリスト名で検索
  name = "com.amazonaws.*.s3"
}