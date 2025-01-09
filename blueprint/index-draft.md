---
title: Integrate work automation with HubSpot
author: marlowe.tutor
indextype: blueprint
icon: blueprint
image: images/overview.png
category: 6
summary: |
  This Genesys Cloud Developer Blueprint explains how to integrate work automation with HubSpot.
---

This Genesys Cloud Developer Blueprint explains how to integrate work automation with HubSpot.

![Work Automation HubSpot Ticketing overview](images/overview.png "Work Automation HubSpot Ticketing overview")

## Solution components

## Prerequisites

### Specialized knowledge

* Experience using the Genesys Cloud Task Management, Integrations and Inbound Call flow

### Genesys Cloud account

* A Genesys Cloud license. For more information, see [Genesys Cloud Pricing](https://www.genesys.com/pricing "Opens the Genesys Cloud pricing page") in the Genesys website.

### HubSpot account

* Create a HubSpot account. For more information, see [Get started with HubSpot](https://app.hubspot.com/signup-hubspot/crm?hubs_signup-cta=login-signup-cta&step=landing_page "Opens the HubSpot account creation page").

## Implementation steps

You can implement Genesys Cloud objects manually or with Terraform.
* [Configure Genesys Cloud using Terraform](#configure-genesys-cloud-using-terraform)
* [Configure Genesys Cloud manually](#configure-genesys-cloud-manually)

### Download the repository containing the project files
Clone the [workautomation-hubspot-ticketing-sample repository](https://github.com/GenesysCloudBlueprints/workautomation-hubspot-ticketing-sample "Goes to the workautomation-hubspot-ticketing-sample repository") in GitHub.

## Configure Genesys Cloud using Terraform

### Set up Genesys Cloud

1. Set the following environment variables in a terminal window before you run this project using the Terraform provider:

   * `GENESYSCLOUD_OAUTHCLIENT_ID` - This variable is the Genesys Cloud client credential grant Id that CX as Code executes against. 
   * `GENESYSCLOUD_OAUTHCLIENT_SECRET` - This variable is the Genesys Cloud client credential secret that CX as Code executes against. 
   * `GENESYSCLOUD_REGION` - This variable is the Genesys Cloud region in your organization.

2. Set the environment variables in the folder where Terraform is running. 

### Configure your Terraform build

* `client_id` - The value of your OAuth Client ID using Client Credentials to be used for the data action integration.
* `client_secret`- The value of your OAuth Client secret using Client Credentials to be used for the data action integration.

```
client_id       = "your-client-id"
client_secret   = "your-client-secret"
account_id      = "12345678"
division_id     = "12345678-1234-1234-1234-001123456789"
email           = "test.email@genesys.com"
```

### Run Terraform

The blueprint solution is now ready for your organization to use. 

1. Change to the **/terraform** folder and issue the following commands:

   * `terraform init` - This command initializes a working directory containing Terraform configuration files.  
   * `terraform plan` - This command executes a trial run against your Genesys Cloud organization and displays a list of all the Genesys Cloud resources Terraform created. Review this list and make sure that you are comfortable with the plan before you continue to the next step.
   * `terraform apply --auto-approve` - This command creates and deploys the necessary objects in your Genesys Cloud account. The `--auto-approve` flag provides the required approval before the command creates the objects.

After the `terraform apply --auto-approve` command successfully completes, you can see the output of the command's entire run along with the number of objects that Terraform successfully created. Keep the following points in mind:

   * This project assumes that you run this blueprint solution with a local Terraform backing state, which means that the `tfstate` files are created in the same folder where you run the project. Terraform recommends that you use local Terraform backing state files **only** if you run from a desktop or are comfortable deleting files.

   * As long as you keep your local Terraform backing state projects, you can tear down this blueprint solution. To tear down the solution, change to the `docs/terraform` folder and issue the  `terraform destroy --auto-approve` command. This command destroys all objects that the local Terraform backing state currently manages.

## Configure Genesys Cloud manually

### Create a private app on HubSpot and obtain access token

1. Create private app on HubSpot

With your account logged in on HubSpot, go to Settings → Account Management → Integrations → Private Apps

![Create private app](images/create-private-app.png "Create private app")

The scope should be set to "tickets"

![Select scope](images/select-scope.png "Select scope")

2. Obtain access token

Once the private app is created, we can now get the access token under the Auth tab

![Obtain access token](images/obtain-access-token.png "Obtain access token")

For integration purposes, we will utilize the HubSpot Insert Ticket API. Hubspot provide rich API see [HubSpot API Docs](https://developers.hubspot.com/docs/api/crm/tickets "Opens the HubSpot API Docs page") to Create/Retrieve/Update/Delete tickets. For Demo purpose, we will only use the Creation API.

### Create workbin, worktype and custom attributes on Genesys Cloud

Genesys Cloud creates workitems using API triggered events. Workitems belong to specific worktypes with custom attributes and are routed automatically to queues like an ACD interaction or are routed using workflows.

1. Create workbin 

![Create workbin](images/create-workbin.png "Create workbin")

* Use this API to find workbin id, which will be used in the subsequent step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").
* Look for Task Management → Query for workbins. 
* Execute the POST request with the following request body.

Post data:
```
{
"filters": [
    {
        "name": "name",
        "type": "String",
        "operator": "IN",
        "values": ["cases"]
    }
]
}
```

![Get workbin id](images/get-workbin-id-api.png "Get workbin id")
![Get workbin id api result](images/get-workbin-id-api-result.png "Get workbin id api result")

2. Create worktype

![Create worktype](images/create-worktype.png "Create worktype")

* Make sure to use the workbin you have created above.

![Select workbin](images/create-worktype-select-workbin.png "Select workbin")

* Use this API to find worktype id, which will be used in the subsequent step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").
* Look for Task Management → Query for worktypes. 
* Execute the POST request with the following request body.
Post data:  

```
{
"filters": [
    {
        "name": "name",
        "type": "String",
        "operator": "IN",
        "values": ["cases"]
    }
]
}
```
![Get worktype id](images/get-worktype-id-api.png "Get worktype id")

* Execute the POST request with the following request body
![Get worktype id api result](images/get-worktype-id-api-result.png "Get worktype id api result")

3. Create custom attributes
![Create custom attributes](images/create-custom-attributes.png "Create custom attributes")

### Add Client Application integration
1. To get the HubSpot URL to use for the Client Application, on HubSpot page search "tickets".
![Search hubspot tickets page](images/search-hubspot-tickets-page.png "Search hubspot tickets page")

2. The URL should look something like this: https://app.hubspot.com/contacts/NNNNNNNN/objects/0-5/views/all/list
![Get hubspot tickets page](images/get-hubspot-tickets-page.png "Get hubspot tickets page")

3. Create a group to use for the Client Application Integration. Go to Directory → Groups. 
![Create group](images/create-group.png "Create group")

4. Create Client Application integration and use the URL above as the Application URL.
![Create client application](images/create-client-application.png "Create client application")

5. Set Client Application integration to active.
![Set application to active](images/set-application-to-active.png "Set application to active")

6. Open the Client Application under Apps → Application
![Open client application](images/open-client-application.png "Open client application")
* Make sure you opened the HubSpot page on the same window with the Genesys Cloud

### Add HB Web Service integration
* Just need to add integration, keep the default configuration.
![Create HB Web Service integration](images/create-hb-web-service.png "Create HB Web Service integration")

### Add oAuth for work automation
* Before adding Data Action for Work Automation API, need to add Oauth and Integration first. For Oauth, please add role have permission on "workitem".
![Add oAuth](images/add-oauth.png "Add oAuth")

### Add integration for work automation
* For Data Action integration, need to use above values to configure client Id and Client Secret for Genesys Cloud Data Actions integration.
![Create data action integration](images/create-data-action-integration.png "Create data action integration")

### Add DataAction for creating HubSpot tickets and workitem
1. Add DataAction for creating HubSpot tickets
* Inside the src folder, edit the 'Add DataAction for creating HubSpot tickets.json' to replace Authorization with your API key from the created HubSpot private app.
```
{
  "name": "Hubspot insert ticket",
  "integrationType": "custom-rest-actions",
  "actionType": "custom",
  "config": {
    "request": {
      "requestUrlTemplate": "https://api.hubapi.com/crm/v3/objects/tickets",
      "requestType": "POST",
      "headers": {
        "Authorization": "Bearer pat-na1-9de5c5c1-XXXX-XXXX-a417-716a3ae3e998",
        "Content-Type": "application/json"
      },
      "requestTemplate": "{\"properties\": {\"hs_pipeline\": \"${input.hs_pipeline}\", \"hs_pipeline_stage\": \"${input.hs_pipeline_stage}\", \"hs_ticket_priority\": \"${input.hs_ticket_priority}\", \"subject\": \"${input.subject}\" }   }"
    },
    "response": {
      "translationMap": {},
      "translationMapDefaults": {},
      "successTemplate": "${rawResult}"
    }
  },
  "contract": {
    "input": {
      "inputSchema": {
        "type": "object",
        "properties": {
          "hs_pipeline": {
            "type": "string"
          },
          "hs_pipeline_stage": {
            "type": "string"
          },
          "hs_ticket_priority": {
            "type": "string"
          },
          "subject": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    },
    "output": {
      "successSchema": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    }
  },
  "secure": false
}
```
* Import the json to Actions
![Import JSON create ticket](images/import-json-create-ticket.png "Import JSON create ticket")

2. Add DataAction for creating workitem
* Inside the src folder, import the 'Add Dataaction for creating workitem.json' to Actions which can be used in the Architect or Script for Demo purpose.
```
{
  "name": "New WorkItem",
  "integrationType": "purecloud-data-actions",
  "actionType": "custom",
  "config": {
    "request": {
      "requestUrlTemplate": "/api/v2/taskmanagement/workitems",
      "requestType": "POST",
      "headers": {},
      "requestTemplate": "{\"name\": \"${input.name}\" ,  \"priority\": ${input.priority}, \"workbinId\": \"${input.workbinId}\", \"typeId\":  \"${input.typeId}\", \"externalContactId\": \"${input.externalcontactid}\"  ,\"customFields\" : {\"casetype_text\": \"${input.casetype_text}\" , \"customername_text\": \"${input.customername_text}\" , \"customernumber_text\": \"${input.customernumber_text}\", \"memo_longtext\": \"${input.memo_longtext}\" , \"hb_ticketid_text\": \"${input.hb_ticketid}\", \"hb_url_url\": \"${input.hb_url}\"}}"
    },
    "response": {
      "translationMap": {},
      "translationMapDefaults": {},
      "successTemplate": "${rawResult}"
    }
  },
  "contract": {
    "input": {
      "inputSchema": {
        "title": "source",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "priority": {
            "type": "integer"
          },
          "workbinId": {
            "type": "string"
          },
          "typeId": {
            "type": "string"
          },
          "casetype_text": {
            "type": "string"
          },
          "customername_text": {
            "type": "string"
          },
          "customernumber_text": {
            "type": "string"
          },
          "memo_longtext": {
            "type": "string"
          },
          "hb_ticketid": {
            "type": "string"
          },
          "externalcontactid": {
            "type": "string"
          },
          "hb_url": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    },
    "output": {
      "successSchema": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    }
  },
  "secure": false
}
```
![Import JSON create workitem](images/import-json-create-workitem.png "Import JSON create workitem")

### Import JSON to script
* In this blueprint, we use script to insert Hubsport Ticket and workitem. You need to import below json to script.

* After import script, you need to configure Actions in the script, associate with above hubspot ticket insert and New workitem dataaction, also need to update the workbinid and worktypeid with previous creation.

### Import Architect Flow for Inbound Call
* You can import Inbound Case_v4-0.i3InboundFlow in your ORG. For Demo/Script integration, need to set screen popup and related input for Inbound Script. You can get the externalcontactID from External Contacts.

### Configure DID with Inbound Call Flow

### Make a test call
* Agent receive the call

* Agent submit the workitem

* Agent receive the workitem

* WorkItem list view

* HubSpot tickets list view

* HubSpot ticket view

## Appendix other use case
1. Trigger and Workflow
* A trigger is a resource within Genesys Cloud that allows customers to configure a reaction to specific events that occur within Genesys Cloud. The actions are workflows that you can create using Architect. We can use the trigger+workflow to do advanced workitems routing after Agents process workitem. 

Usecase:

Agent receive the workitem, Change Status from "Open" or any other status to "On Hold", then park it.
Matching the predefined trigger, launch the configured Architect workflow.
Worflow get the JSON data, and send a email to a User.

1. Create an architect workflow

2. Create a trigger

3. Assign workitem to Queue in workflow