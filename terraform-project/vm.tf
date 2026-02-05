data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  count       = 2
  name        = "vm${count.index}"
  platform_id = "standard-v1"
  zone        = yandex_vpc_subnet.subnet1.zone

  resources {
    cores         = var.vm.cores
    memory        = var.vm.memory
    core_fraction = var.vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 8
    }
  }
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
}

