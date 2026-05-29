terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "mathpracs-tfstate-rg"
    storage_account_name = "mathpracstfstate"
    container_name       = "tfstate"
    key                  = "static-site.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project = var.project_name
  }
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    project = var.project_name
  }
}

# Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "${var.project_name}-fd-profile"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard_AzureFrontDoor"

  tags = {
    project = var.project_name
  }
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "${var.project_name}-fd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  tags = {
    project = var.project_name
  }
}

# Front Door Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                     = "${var.project_name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {}
}

# Front Door Origin (points to storage account)
resource "azurerm_cdn_frontdoor_origin" "main" {
  name                           = "storage-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main.id
  host_name                      = azurerm_storage_account.main.primary_web_host
  origin_host_header             = azurerm_storage_account.main.primary_web_host
  https_port                     = 443
  http_port                      = 80
  enabled                        = true
  certificate_name_check_enabled = false
}

# Front Door Route
resource "azurerm_cdn_frontdoor_route" "main" {
  name                          = "${var.project_name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.main.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  enabled                       = true
}