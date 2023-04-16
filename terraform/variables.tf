variable "yc_token" {
   default = ""
}

variable "yc_cloud_id" {
  default = ""
}

variable "yc_folder_id" {
  default = ""
}

variable "yc_region" {
  default = "ru-central1-a"
}

variable "yc_user_name" {
  default = ""
}

variable "yc_public_key" {
  default = ""
}

locals {
# node instance settings
  node_instance_count = {
    stage = 1
    prod  = 1
  }
  node_cores = {
    stage = 2
    prod  = 2
  }
  node_memory = {
    stage = 2
    prod  = 2
  }
  node_disk_size = {
    stage = 20
    prod  = 40
  }

#Network settings
  vpc_subnets = {
    stage = [
    {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.130.0.0/24"]
    },
    {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.129.0.0/24"]
    },
    {
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.128.0.0/24"]
    }
    ]
    prod = [
    {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.20.0.0/24"]
    },
    {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.21.0.0/24"]
    },
    {
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.22.0.0/24"]
    }
    ]
  }
}
