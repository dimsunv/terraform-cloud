module "vpc" {
  source = "../modules/vpc"
  description   = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  yc_folder_id  = var.yc_folder_id
  name          = terraform.workspace
  subnets       = local.vpc_subnets[terraform.workspace]
  nat_instance  = true
  user_name     = var.yc_user_name
  public_key    = var.yc_public_key
}

module "node" {
  source         = "../modules/instance"
  instance_count = local.node_instance_count[terraform.workspace]
  subnet_id      = module.vpc.subnet_ids[0]
  zone           = var.yc_region
  folder_id      = module.vpc.folder_id
  image          = "centos-stream-8"
  platform_id    = "standard-v2"
  name           = "node"
  description    = ""
  instance_role  = "netology_k8s_cluster"
  cores          = local.node_cores[terraform.workspace]
  boot_disk      = "network-hdd"
  disk_size      = local.node_disk_size[terraform.workspace]
  nat            = "false"
  memory         = local.node_memory[terraform.workspace]
  core_fraction  = "100"
  user_name      = var.yc_user_name
  public_key     = var.yc_public_key
  
  depends_on = [
    module.vpc
  ]
}