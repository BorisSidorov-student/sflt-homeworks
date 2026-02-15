data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

# Создаем группу виртуальных машин фиксированного размера с сетевым балансировщиком нагрузки
resource "yandex_compute_instance_group" "ig-1" {
  name = "ig-with-balancer"
  folder_id = "b1giqelfm5ddkhijael0"
  service_account_id = "aje9na5ena48kcv3rh22"
  deletion_protection = "false"

  instance_template{
    platform_id = "standard-v1"
    name = "vm-{instance.index}"
    resources {
      memory = var.vm.memory
      cores = var.vm.cores
      core_fraction = var.vm.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
        type     = "network-hdd"
        size     = 8
      }
    }

    scheduling_policy { preemptible = true }

    network_interface {
      network_id = yandex_vpc_network.develop.id
      subnet_ids = [yandex_vpc_subnet.subnet1.id]
      nat = true
    }

    metadata = {
      user-data          = file("./cloud-init.yml")
      serial-port-enable = 1
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [yandex_vpc_subnet.subnet1.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }

  load_balancer {
    target_group_name = "tg1"
    target_group_description = "Целевая группа NLB"
  }
}

# resource "yandex_compute_instance" "vm" {
#   count       = 2
#   name        = "vm${count.index}"
#   platform_id = "standard-v1"
#   zone        = yandex_vpc_subnet.subnet1.zone

#   resources {
#     cores         = var.vm.cores
#     memory        = var.vm.memory
#     core_fraction = var.vm.core_fraction
#   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
#       type     = "network-hdd"
#       size     = 8
#     }
#   }
#   metadata = {
#     user-data          = file("./cloud-init.yml")
#     serial-port-enable = 1
#   }

#   scheduling_policy { preemptible = true }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.subnet1.id
#     nat       = true
#   }
# }