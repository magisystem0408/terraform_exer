//外部からデータを取得するときに使用する
#結果的にtf.stateのなかに書き込まれる

#プレフィックスリストを定義
data "aws_prefix_list" "s3_pl" {
  #  プレフィックスリスト名で検索
  name = "com.amazonaws.*.s3"
}

#AMIの検索
data "aws_ami" "app" {

  #  最新のものを選択するかどうか
  #  下記で検索してから最新のものを選択するかどうか
  most_recent = true

  #  所有者(検索条件)
  owners = ["self", "amazon"]

  #  検索フィルター
  filter {
    #    amiそのもの
    name = "name"
    #    ここで*にすることで複数検索できるようになる、
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    #    接続するブロックストレージの種類：基本はebs
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    #    仮想化方式。：基本はhvm
    name   = "virtualization-type"
    values = ["hvm"]
  }
}