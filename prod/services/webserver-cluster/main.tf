terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  
  backend "s3" {

    bucket         = "terraform-state-2416"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true

  }
  
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

   ami         = "ami-0fb653ca2d3203ac1"
   server_text = var.server_text

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-state-2416"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
  enable_autoscaling   = true

   custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
  }
}
