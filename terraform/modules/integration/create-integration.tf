resource "genesyscloud_integration" "hubspot_integration" {
  intended_state   = "DISABLED"
  integration_type = "embedded-client-app"
  config {
    name = "hubspot_integration name"
    properties = jsonencode({
      "displayType" = "standalone",
      "sandbox"     = "allow-scripts,allow-same-origin,allow-forms,allow-modals",
      "url"         = "https://app.hubspot.com/contacts/47503242/objects/0-5/views/all/list"
      # Potential groups and queues filter (Need to look up the key name from integration type schema)
      "groups" = [var.group_id]
    })
    advanced = jsonencode({})
    notes    = "Test config notes"
  }
}