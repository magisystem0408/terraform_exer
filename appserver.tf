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

#パラメータストア作成
#address
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}

#ポート番号
resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}

#データベース名
resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.name
}

#ユーザー名
resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type  = "String"
  value = aws_db_instance.mysql_standalone.username
}

#パスワード
resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.password
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

  #インスタンスプロフィール関連を接続(iam)
  iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name

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

