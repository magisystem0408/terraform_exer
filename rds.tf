#パラメータグループの作成
resource "aws_db_parameter_group" "mysql-standalone-prameter_group" {
  name   = "${var.project}-${var.environment}-mysql-standalone-prameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

#オプショングループ
resource "aws_db_option_group" "mysql_standalone_option_group" {
  name = "${var.project}-${var.environment}-mysql-standardalone-option-group"
  #  環境指定(必須項目)
  engine_name = "mysql"
  #  バージョン指定
  major_engine_version = "8.0"
}

#サブネットグループ(どこに配置するか)
resource "aws_db_subnet_group" "mysql_standalone_subnet_group" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"

  #  配置する場所のidで紐付けする
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id,
  ]
  tags = {
    Name    = "${var.project}-${var.environment}-private_subnet_1a"
    Project = var.project
    Env     = var.environment
  }
}

#DBインスタンス用のパスワードを作成する(直し、パスワードのモジュールを入れないといけないのでterraform initをする)
resource "random_string" "db_password" {
  length = 16
  #  特殊文字を使用するかどうか
  special = false
}


#インスタンス
resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"
  engine_version = "8.0.20"

  #RDSを識別する名前
  identifier = "${var.project}-${var.environment}-mysql-standalone"

  #  ユーザー名
  username = "admin"
  #  パスワード名
  #  最後にresultをつける
  password = random_string.db_password.result

  #  インスタンスタイプ
  instance_class = "db.t2.micro"

  #  ストレージ周りの設定
  #  デフォルトの値(20GB)
  allocated_storage = 20
  #  最大容量
  max_allocated_storage = 50
  #  タイプ設定(デフォルト設定)
  storage_type = "gp2"
  #  暗号化するか
  storage_encrypted = false

  #  ネットワーク周り
  #  マルチA-Zにするか
  multi_az = false
  #  マルチA-Zを行わないのでアベイラビリティゾーンを指定する
  availability_zone = "ap-northeast-1a"
  #  サブネットグループ
  db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnet_group.name
  #  セキュリティグループ
  vpc_security_group_ids = [aws_security_group.db_sg.id, ]
  #  パブリックからアクセスさせるかどうか
  publicly_accessible = false
  #  ポート番号
  port = 3306


  #  データベース設定まわり
  name = "tastylog"
  #  パラメータグループの紐付け
  parameter_group_name = aws_db_parameter_group.mysql-standalone-prameter_group.name
  #  オプショングループの紐付け
  option_group_name = aws_db_option_group.mysql_standalone_option_group.name

  #  メンテナンス系設定

  #  backアップを先にスタートさせるようにする
  #  行う時間
  backup_window = "04:00-05:00"
  #  どれぐらい保管するか
  backup_retention_period = 7
  #  メンテナンスを行う時間帯
  maintenance_window = "Mon:05:00-Mon:08:00"
  #  自動的に更新するか
  auto_minor_version_upgrade = false

  #  自動で削除するか
  deletion_protection = false
  #  削除時のスナップショットをスキップするか
  skip_final_snapshot = true
  #  即時反映するか
  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone",
    Project = var.project
    Env     = var.environment
  }


}