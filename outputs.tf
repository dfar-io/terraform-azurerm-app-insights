output "instrumentation_key" {
  description = "Instrumentation key provided by resource."
  value       = "${azurerm_application_insights.ai.instrumentation_key}"
}
