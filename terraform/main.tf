module "vpc" {
    source  = ".s//modules/vpc"
    project_id   = "<PROJECT ID>"
    network_name = "example-vpc"
}

