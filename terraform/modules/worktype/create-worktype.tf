resource "genesyscloud_task_management_worktype" "hubspot_worktype" {
  name        = "HubSpot Worktype"
  description        = "Description for my worktype"
  default_workbin_id = genesyscloud_task_management_workbin.workbin.id
  schema_id          = genesyscloud_task_management_workitem_schema.schema.id
  schema_version     = 4
  division_id        = data.genesyscloud_auth_division_home.home.id
}