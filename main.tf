# Create resource group for k8s cluster
resource "azurerm_resource_group" "main" {
  name     = "${local.name}-k8s-rg"
  location = var.location
}


# Use module to provision the k8s cluster
module "aks" {
  source                 = "github.com/germanium-git/terraform-modules/azure-k8s"
  cluster_name           = "${local.name}demo"
  azurerm_resource_group = azurerm_resource_group.main
  node_count             = var.node_count
}


# Save the k8s config into the file
resource "local_file" "kubeconfig" {
  content  = module.aks.kubeconfig
  filename = "kubeconfig"
}


# Create IP address for k8s ingress
resource "azurerm_public_ip" "ingress" {
  name                = "${local.name}-ingress-ip"
  resource_group_name = module.aks.azurerm_kubernetes_cluster.node_resource_group
  location            = module.aks.azurerm_kubernetes_cluster.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Production"
  }
}


# Create A record in Cloudflare DNS for the LB used by ingress service
resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name    = local.name
  value   = azurerm_public_ip.ingress.ip_address
  type    = "A"
}


# Create CNAME record in Cloudflare DNS for all ingress services accessible through the LB specified by A record
resource "cloudflare_record" "wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*.${cloudflare_record.root.name}"
  value   = cloudflare_record.root.hostname
  type    = "CNAME"
}
