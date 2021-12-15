//terraform configure
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  #  tfstateをs3に置くことによって競合開発環境を可能にさせる
  #  これをやったときinitが必要になる
  backend "s3" {
    bucket  = "tastylog-tsstate-bucket-nekomamushi"
    key     = "tastylog-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

//プロバイダー選択
provider "aws" {
  #  ここでawsConfigureのプロファイルを切り替えられる
  profile = "terraform"
  region  = "ap-northeast-1"
}

//環境変数のinterfaceを定義
variable "project" {
  type = string
}

variable "environment" {
  type = string
}


variable "domain" {
  type = string
}