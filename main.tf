//terraform configure
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

//プロバイダー選択
provider "aws" {
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