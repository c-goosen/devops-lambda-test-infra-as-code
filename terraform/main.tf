provider "aws" {
  region = "eu-west-1"
  version = "~> 2.0"

}
# variable ctrl_vpc{
#   type    = "string"
#   default = "vpc-a2592ec4"
# }
module "iam"{
  source = "./iam/"
}

module "server"{
  source = "./server/"
}
