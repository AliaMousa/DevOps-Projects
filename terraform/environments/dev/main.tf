module "vpc" {
  source  = "/home/alia/GitHub_project/gcp_project/terraform/modules/vpc"
  name    = "vpcdev"
  subnet1 = "dev-private-subnet1"
  region  = "us-east1"
  project = "your-project-id"
}

module "vm" {
  source     = "/home/alia/GitHub_project/gcp_project/terraform/modules/vm"
  zone       = "us-east1-c"
  network    = module.vpc.network
  subnetwork = module.vpc.subnet_id
  project = "your-project-id"
  instances  = module.vm.vm_id
}

module "iap" {
  source  = "/home/alia/GitHub_project/gcp_project/terraform/modules/iap"
  project = "your-project-id"
}

module "lb" {
  source         = "/home/alia/GitHub_project/gcp_project/terraform/modules/lb"
  group = module.vm.group
}
