variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "static-site-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Must be globally unique, lowercase, 3-24 chars"
  type        = string
}

variable "project_name" {
  description = "Used for tagging resources"
  type        = string
  default     = "azure-static-site"
}