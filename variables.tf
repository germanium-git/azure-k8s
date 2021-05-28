#Specify Azure region to deploy AKS
variable "location" {
  default = "West Europe"
}

#Specify a Local value to derive unique names for resource group, k8s cluster, ingress-ip etc.
locals {
  name = "nemedpet"
}

#Cloudflare token - Add a valid token with permission to create DNS records to the terraform.tfvars file
variable "cloudflare_api_token" {
}

#Cloudflare Zone ID - Add DNS zone ID to the terraform.tfvars file
variable "cloudflare_zone_id" {
}

#Azure Subscription - Add subscription ID to the terraform.tfvars file
variable "subscription_id" {
}

#Number of k8s nodes
variable "node_count" {
  default = 2
}
