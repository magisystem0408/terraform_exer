#アプリケーションサーバー用

#キーペアの登録
resource "aws_key_pair" "keypair" {
  key_name = "${var.project}-${var.environment}-keypair"
  #  公開鍵のアップロードの指定
  #  ファイルを直接選ぶ
  public_key = file("./src/tastlog-dev-keypair.pub")

  tags = {
    Name : "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}


#EC2インスタンス作成
resource "aws_instance" "app_server" {
  ami = data.aws_ami.app.id
  #  インスタンスタイプの設定
  instance_type = "t2.micro"
  #  サブネット
  subnet_id = aws_subnet.public_subnet_1a.id
  #  パブリックIP自動割り当て
  associate_public_ip_address = true

  #  セキュリティグループ
  vpc_security_group_ids = [
    #    アプリケーションサーバー
    aws_security_group.app_sg.id,
    #    運用管理用
    aws_security_group.opmg_sg.id,
  ]

  #  キーペア
  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name : "${var.project}-${var.environment}-app-ec2"
    Project : var.project
    Env  = var.environment
    Type = "app"
  }

}