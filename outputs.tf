
output "id" {
  description = "ID of the Talos template VM"
  value       = proxmox_virtual_environment_vm.template.id
}

output "name" {
  description = "Name of the Talos template VM"
  value       = var.template_name
}

output "tags" {
  description = "Tags of the Talos template VM"
  value       = var.tags
}
