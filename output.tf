# Display k8s LB public IP
output "ingress-ip" {
  value     = azurerm_public_ip.ingress.ip_address
  sensitive = false
}

# Display k8s API public IP
output "k8s-api-url" {
  value     = module.aks.k8s_api_url
  sensitive = false
}