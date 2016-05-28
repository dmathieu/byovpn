variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-central-1"
}

variable "vpn_user" {}
variable "vpn_password" {}
variable "vpn_phrase" {}

variable "amis" {
    default = {
      ap-northeast-1 = "ami-20b6aa21"
      ap-southeast-1 = "ami-ca381398"
      ap-southeast-2 = "ami-abeb9e91"
      eu-central-1   = "ami-9a380b87"
      eu-west-1      = "ami-234ecc54"
      sa-east-1      = "ami-69f54974"
      us-east-1      = "ami-9a562df2"
      us-west-1      = "ami-5c120b19"
      us-west-2      = "ami-29ebb519"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}
