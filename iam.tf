
#インスタンスプロフィール
#ec2にiamロールを取り付ける時に、インスタンスプロフィールを介して取り付ける必要がある。
resource "aws_iam_instance_profile" "app_ec2_profile" {
  #  nameはiamロールと一致にさせる
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}

# iam roleを作成
resource "aws_iam_role" "app_iam_role" {
  name = "${var.project}-${var.environment}-app-iam-role"
  #  iamのポリシー
  #  ポリシー作成したときにできるjsonを指定する
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


#信頼ポリシーの作成
data "aws_iam_policy_document" "ec2_assume_role" {
  #  ここら辺は自動作成される、おまじない
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


#ポリシーアタッチ
resource "aws_iam_role_policy_attachment" "app_iam_role_ec2_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_managed" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_s3_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

