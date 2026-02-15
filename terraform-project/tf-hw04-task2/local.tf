# resource "local_file" "inventory" {
#   content = <<-EOF
# all:
#   hosts:
#     ${yandex_compute_instance.vm[0].name}:
#       ansible_host: ${yandex_compute_instance.vm[0].network_interface.0.nat_ip_address}
#       ansible_user: ${var.user_name}

#     ${yandex_compute_instance.vm[1].name}:
#       ansible_host: ${yandex_compute_instance.vm[1].network_interface.0.nat_ip_address}
#       ansible_user: ${var.user_name}
#   vars:    
#     ansible_ssh_common_args: '-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null'

# EOF
#   filename =  "./inventory.yml"
# }

# locals {
#   vm_list = [
#     for instance in yandex_compute_instance.vm :{
#       name = instance.name
#       nat_ip = instance.network_interface.0.nat_ip_address
#       user = var.user_name
#     }
#   ]
# }