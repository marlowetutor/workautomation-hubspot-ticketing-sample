resource "genesyscloud_task_management_workbin" "hubspot_workbin" {
  name        = "HubSpot Workbin"
  workbin_id  = genesyscloud_task_management_workbin.workbin.id
  division_id        = data.genesyscloud_auth_division_home.home.id
}