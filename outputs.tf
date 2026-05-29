output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "static_website_url" {
  description = "Direct URL of the static website from storage"
  value       = azurerm_storage_account.main.primary_web_endpoint
}

output "frontdoor_endpoint_url" {
  description = "Front Door endpoint URL"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
}