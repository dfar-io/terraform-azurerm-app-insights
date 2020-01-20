variable "name" {
  description = "Name of Application Insights resource."
}
variable "location" {
  description = "Location of Application Insights resource."
}
variable "rg_name" {
  description = "Name of containing Resource Group."
}
variable "web_tests" {
  description = "A map of web tests (name and URL) to include with resource."
  default     = {}
}
variable "action_group_id" {
  description = "The ID of the action group to activate for availability alerts."
  default     = null
}
