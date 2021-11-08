#アプリケーションサーバー用

#キーペアの登録
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  #  公開鍵のアップロードの指定
  #  ファイルを直接選ぶ
  public_key = file("./src/tastlog-dev-keypair.pub")

  tags = {
    Name : "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}