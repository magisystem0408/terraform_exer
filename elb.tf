#ALB

resource "aws_lb" "alb" {
  name = "${var.project}-${var.environment}-app-alb"
  #  外向け
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id,
  ]
}

#ターゲットグループ
resource "aws_lb_target_group" "alb_target_group" {
  name ="${var.project}-${var.environment}-app-tg"
  port=3000
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-app-tg"
    Project = var.project
    Env  = var.environment
  }
}

#ターゲットグループアタッチメント
resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn

  #  所属させたいインスタンス
  target_id        = aws_instance.app_server.id
}