//外からデータを取り出していく時に仕様する

data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3"
}