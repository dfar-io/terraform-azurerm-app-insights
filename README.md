# terraform-azurerm-app-insights
Terraform Module to provide Application Insights with included web tests.

Features:
- Can include a map to create web tests automatically
- Allows for setting up actions with request failures (500 errors)
- Connect to function app or app service based on instrumentation key output

## Usage

Create an Application Insights instance with included web tests:

```
provider "azurerm" {
  version         = "=1.36"
}

resource "azurerm_resource_group" "rg" {
  name     = "test-rg"
  location = "Central US"
}

module "app-insights" {
  source  = "dfar-io/app-insights/azurerm"
  version = "1.2.1"
  name = "my-application-insights"
  location = azurerm_resource_group.rg.location
  rg_name = azurerm_resource_group.rg.name
  web_tests = {
    ui-uptime = <<EOF
    https://my-web-site.com/status
    EOF
    api-uptime = <<EOF
    https://my-web-site.com/api/status
    EOF
  }
}
```
