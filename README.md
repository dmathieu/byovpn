# Bring your own VPN

Terraform script to boot a VPN on EC2 for ephemeral use.

## Setup

You need a local SSH key to connect to the instance.

> ssh-keygen -t rsa -b 4096 -C "you@example.com"

## Usage

Boot the VPN:

> terraform apply

Note: you may want to store the config variables in a `terraform.tfvars` file
to avoid having to type them every time.

Stop the VPN:

> terraform destroy
