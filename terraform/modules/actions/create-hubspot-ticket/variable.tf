variable "action_name" {
  type        = string
  description = "Name to associate with action"
}

variable "action_category" {
  type        = string
  description = "Action category to associate with action"
}

variable "integration_id" {
  type        = string
  description = "ID of the integration this action is associated with"
}

variable "bearer_token" {
  type        = string
  description = "The Bearer Token to be used by Data Actions"
}