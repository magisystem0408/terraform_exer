//セキュリティグループ

//webサーバー用のセキュリティグループ

resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    project = var.project
    Env     = var.environment
  }
}

//インバウンド定義
resource "aws_security_group_rule" "web_in_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  to_port           = 443
  type              = "ingress"
  //  ciderかsource_security_groupで指定する
  cidr_blocks = ["0.0.0.0/0"]
}

//アウトバウンド定義
resource "aws_security_group_rule" "web_out_tcp3000" {
  //  開始ポート番号
  from_port         = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  //  終了ポート番号
  to_port = 3000
  //  インバウンド(ingress)かアウトバウンド(egress)か
  type = "egress"

  //  ciderかsource_security_groupで指定する
  source_security_group_id = aws_security_group.app_sg.id
}


#アプリケーション用のセキュリティグループ
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

#インバウンド定義
resource "aws_security_group_rule" "app_in_tcp3000" {
  //  開始ポート番号
  from_port         = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.app_sg.id
  //  終了ポート番号
  to_port = 3000
  //  インバウンド(ingress)かアウトバウンド(egress)か
  type = "ingress"

  //  ciderかsource_security_groupで指定する
  source_security_group_id = aws_security_group.web_sg.id
}


resource "aws_security_group_rule" "app_out_tcp3000" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  #  プレフィックスリストを設定するときは専用のものがある。
  prefix_list_ids = [data.aws_prefix_list.s3_pl.id]
}

#app→httpへのアウトバウンド
resource "aws_security_group_rule" "app_out_http" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

#app→DBのアウトバウンド
resource "aws_security_group_rule" "app_out_tcp3306" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}


//運用管理用のセキュリティグループ
resource "aws_security_group" "opmg_sg" {
  name        = "${var.project}-${var.environment}-opmg-sg"
  description = "operation and management role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}


#インバウンド
#ssh用
resource "aws_security_group_rule" "opmg_in_ssh" {
  security_group_id = aws_security_group.opmg_sg.id
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#https用
resource "aws_security_group_rule" "opmng_in_tcp3000" {
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.opmg_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3000
  to_port           = 3000
}

#アウトバウンド
#http用ポート
resource "aws_security_group_rule" "opmng_out_http" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#https用ポート
resource "aws_security_group_rule" "opmng_out_https" {
  security_group_id = aws_security_group.opmg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

//データベース用のセキュリティグループ
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "operation and management role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

#インバウンド用
resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id = aws_security_group.db_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306

  #  アプリケーションサーバーからネットワークが入ってくる
  source_security_group_id = aws_security_group.app_sg.id
}



