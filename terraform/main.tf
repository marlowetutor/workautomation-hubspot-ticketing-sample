// Create a Data Action integration
module "data_action" {
  source                          = "git::https://github.com/GenesysCloudDevOps/public-api-data-actions-integration-module?ref=main"
  integration_name                = " Interaction"
  integration_creds_client_id     = var.client_id
  integration_creds_client_secret = var.client_secret
}

// Add DataAction for creating HubSpot tickets
module "get_agent_id_data_action" {
  source             = "./modules/actions/hubspot-interaction"
  action_name        = "HubSpot Interaction"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
}

// Add Workbin for creating HubSpot tickets
module "create_workbin" {
  source             = "./modules/workbin"
}

