resource "azurerm_application_insights" "ai" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = "web"
}

resource "azurerm_application_insights_web_test" "test" {
  count                   = length(keys(var.web_tests))
  name                    = element(keys(var.web_tests), count.index)
  location                = var.location
  resource_group_name     = var.rg_name
  application_insights_id = azurerm_application_insights.ai.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 120
  enabled                 = true
  retry_enabled           = true
  geo_locations = ["us-tx-sn1-azr", "us-il-ch1-azr", "us-ca-sjc-azr",
  "us-va-ash-azr", "us-fl-mia-edge"]

  configuration = <<XML
<WebTest Name="${element(keys(var.web_tests), count.index)}" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="${element(values(var.web_tests), count.index)}" ThinkTime="0" Timeout="0" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
}

resource "azurerm_monitor_metric_alert" "request_failures_alert" {
  name                = "${var.name} - Request failures greater than 0"
  resource_group_name = var.rg_name
  scopes              = [azurerm_application_insights.ai.id]
  description         = "Action will be triggered when request failures are reported."

  criteria {
    metric_namespace = "Microsoft.Insights/Components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0
    
    dimension {
      name     = "request/resultCode"
      operator = "Include"
      values   = ["0", "500"]
    }
  }

    dynamic "action" {
      for_each = var.action_group_id != "" ? [""] : []
      content {
        action_group_id = var.action_group_id
      }
    }
}
