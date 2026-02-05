#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop-${var.flow}"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
}

# создаем таргет группы
resource "yandex_lb_target_group" "group1" {
  name = "group1"
  
  dynamic target {
    for_each = yandex_compute_instance.vm
    content {
      subnet_id = yandex_vpc_subnet.subnet1.id
      address = target.value.network_interface.0.ip_address
    }
  }
}

# создаем балансировщик сетевой нагрузки (Network Load Balancer)
resource "yandex_lb_network_load_balancer" "develop_nlb" {
  name = "develop-load-balancer"

  listener {
    name = "develop-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.group1.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }    
}

