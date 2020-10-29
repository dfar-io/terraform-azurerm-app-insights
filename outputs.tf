output "instrumentation_key" {
  description = "Instrumentation key provided by resource."
  value       = azurerm_application_insights.ai.instrumentation_key
}

output "connection_string" {
  description = "Connection string provided by resource."
  value       = azurerm_application_insights.ai.connection_string
}

output "id" {
  description = "Object ID of the App Insights instance."
  value       = azurerm_application_insights.ai.id
}
