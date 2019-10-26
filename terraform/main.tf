#main terraform file
# main.tf uses modules for specific infrastructure areas
# user seperated from Iam as it was done later

provider "aws" {
  region = "eu-west-1"
  version = "~> 2.0"

}

module "user"{
  source = "./user/"
}
module "iam"{
  source = "./iam/"
}

module "server"{
  source = "./server/"
}
