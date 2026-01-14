# Terraform module for Proxmox VE

This Terraform module allows you to create Virtual Machine template of Talos Linux

## Usage Example

```hcl
variable "instances" {
  description = "Map of Nodes to enable Talos template creation"
  type        = map(any)
  default = {
    "node-1" = {
      enabled     = true,
      template_id = 1042,
    },
    "node-2" = {
      enabled     = true,
      template_id = 1043,
    },
  }
}

module "talos_template" {
  for_each = { for zone, params in var.instances : zone => params if lookup(params, "enabled", false) }
  source = "github.com/sergelogvinov/terraform-proxmox-template-talos"

  node               = each.key
  template_id        = each.value.template_id
  template_datastore = "system"

  template_network_dns = ["1.1.1.1", "2001:4860:4860::8888"]
  template_network = {
    "vmbr0" = {
      firewall = true
    }
  }
}
```

Common variables to override:

- `talos_version` - Version of Talos to download
- `talos_factory_hash` - Hash of the Talos factory image to download
   - `376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba` - customization: {}
   - `14e9b0100f05654bedf19b92313cdc224cbff52879193d24f3741f1da4a3cbb1` - customization: siderolabs/binfmt-misc
   - `ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515` - customization: siderolabs/qemu-guest-agent
- `datastore` - Datastore to store the Talos image (default: `local`)
- `template_datastore` - Datastore to store the Talos template (default: `local`)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.93.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.93.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_download_file.talos](https://registry.terraform.io/providers/bpg/proxmox/0.93.0/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_vm.template](https://registry.terraform.io/providers/bpg/proxmox/0.93.0/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datastore"></a> [datastore](#input\_datastore) | Datastore to store the Talos image | `string` | `"local"` | no |
| <a name="input_node"></a> [node](#input\_node) | Proxmox node name where VM template will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the VM | `list(string)` | <pre>[<br/>  "talos"<br/>]</pre> | no |
| <a name="input_talos_factory_hash"></a> [talos\_factory\_hash](#input\_talos\_factory\_hash) | Hash of the Talos factory image to download | `string` | `"376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"` | no |
| <a name="input_talos_image_name"></a> [talos\_image\_name](#input\_talos\_image\_name) | Name of the Talos image to download | `string` | `"talos.raw.xz.img"` | no |
| <a name="input_talos_secureboot"></a> [talos\_secureboot](#input\_talos\_secureboot) | Whether to use the secureboot Talos image | `bool` | `false` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Version of Talos of template to download | `string` | `"v1.12.1"` | no |
| <a name="input_template_datastore"></a> [template\_datastore](#input\_template\_datastore) | Datastore to store the Talos template | `string` | `"local"` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | ID of the Talos template VM | `number` | n/a | yes |
| <a name="input_template_name"></a> [template\_name](#input\_template\_name) | Name of the Talos template VM | `string` | `"talos"` | no |
| <a name="input_template_network"></a> [template\_network](#input\_template\_network) | n/a | `map(any)` | <pre>{<br/>  "vmbr0": {}<br/>}</pre> | no |
| <a name="input_template_network_dns"></a> [template\_network\_dns](#input\_template\_network\_dns) | n/a | `list(string)` | `[]` | no |
| <a name="input_template_pool"></a> [template\_pool](#input\_template\_pool) | Name of the Talos template VM pool | `string` | `""` | no |
| <a name="input_template_tpm"></a> [template\_tpm](#input\_template\_tpm) | Whether to enable TPM for the Talos template VM | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the Talos template VM |
| <a name="output_name"></a> [name](#output\_name) | Name of the Talos template VM |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags of the Talos template VM |
<!-- END_TF_DOCS -->