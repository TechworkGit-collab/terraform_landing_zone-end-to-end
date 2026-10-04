terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }

  # backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id = "5ef4ee5d-6bd4-4c27-acc2-af8816fed413"
}
