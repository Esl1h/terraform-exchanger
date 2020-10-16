provider "aws" {
    shared_credentials_file = var.credential
    region                  = var.region
    profile                 = var.profile

}
