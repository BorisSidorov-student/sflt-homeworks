variable "cloud_id" {
    type = string
}

variable "folder_id" {
    type = string
}

variable "flow" {
  type    = string
  default = "my-network"
}

variable "vm" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

variable "user_name" {
  type = string
}