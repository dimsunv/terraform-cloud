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

module "master-node" {
  source         = "../modules/instance"
  instance_count = 1
  subnet_id      = module.vpc.subnet_ids[0]
  zone           = "ru-central1-a"
  folder_id      = module.vpc.folder_id
  image          = "centos-stream-8"
  platform_id    = "standard-v2"
  name           = "master-node-${module.vpc.subnet_ids[0]}"
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

module "worker-node-1" {
  source         = "../modules/instance"
  instance_count = 1
  subnet_id      = module.vpc.subnet_ids[1]
  zone           = "ru-central1-b"
  folder_id      = module.vpc.folder_id
  image          = "centos-stream-8"
  platform_id    = "standard-v2"
  name           = "worker-node-${module.vpc.subnet_ids[1]}"
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
    module.master-node
  ]
}

module "worker-node-2" {
  source         = "../modules/instance"
  instance_count = 1
  subnet_id      = module.vpc.subnet_ids[2]
  zone           = "ru-central1-c"
  folder_id      = module.vpc.folder_id
  image          = "centos-stream-8"
  platform_id    = "standard-v2"
  name           = "worker-node-${module.vpc.subnet_ids[2]}"
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
    module.worker-node-1
  ]
}

module "gitlab-server" {
  source         = "../modules/instance"
  instance_count = 1
  subnet_id      = module.vpc.subnet_ids[0]
  zone           = "ru-central1-a"
  folder_id      = module.vpc.folder_id
  image          = "centos-stream-8"
  platform_id    = "standard-v2"
  name           = "gitlab"
  description    = ""
  instance_role  = "gitlab"
  cores          = local.gitlab_cores[terraform.workspace]
  boot_disk      = "network-hdd"
  disk_size      = local.gitlab_disk_size[terraform.workspace]
  nat            = "true"
  memory         = local.gitlab_memory[terraform.workspace]
  core_fraction  = "100"
  user_name      = var.yc_user_name
  public_key     = var.yc_public_key
  
  depends_on = [
    module.worker-node-2
  ]
}