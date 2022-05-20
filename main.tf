terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
    backend "s3" {
        bucket         = "chriseduarte-bucket-1"
        key            = "terraform-state/tf.tfstate"
        region         = "us-west-1"
    }
}

module "vpc" {
    source  = "./modules/vpc"
}

module "lg" {
    source = "./modules/lg"
}

module "asg" {
    source = "./modules/asg"
}