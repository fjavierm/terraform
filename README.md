# terraform
Playing around with terraform. Just a small introduction following in the line of:

[![Terraform Course - Automate your AWS cloud infrastructure](https://img.youtube.com/vi/SLB_c_ayRMo/0.jpg)](https://www.youtube.com/watch?v=SLB_c_ayRMo)

All the merit to them.

## Commands

* `init` - The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

* `validate` - The `terraform validate` command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

* `plan` - The `terraform plan` command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

* `apply` - The `terraform apply` command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.

* `destroy` - The `terraform destroy` command is used to destroy the Terraform-managed infrastructure.

Option `--auto-approve` skips the confirmation (yes).

* `state list` - The `terraform state list` command is used to list resources within a Terraform state.

* `state show` - The `terraform state show` command is used to show the attributes of a single resource in the Terraform state.

To check the output. To avoid executing `apply` we can execute `refresh` first.

* `output` - The `terraform output` command is used to extract the value of an output variable from the state file.

* `refresh` - The `terraform refresh` command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file.