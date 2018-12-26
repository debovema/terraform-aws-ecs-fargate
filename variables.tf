variable "namespace" {
  description = "Namespace"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

# Load Balancer
variable "alb_health_check_unhealthy_threshold" {
  description = "Health check unhealthy thresold"
  type        = "string"
  default     = "4"
}

variable "alb_health_check_interval" {
  description = "Health check interval (in seconds)"
  type        = "string"
  default     = "30"
}

variable "alb_http_port" {
  description = "HTTP port exposed by the Load Balancer"
  type        = "string"
  default     = "80"
}

variable "az_count" {
  description = "Number of availability zones in the region to use"
  type        = "string"
  default     = "2"
}

variable "ecs_enabled" {
  type        = "string"
  default     = "true"
  description = "Whether to create an ECS cluster or not. Other resources such as VPC, ALB and subnets will always be created"
}
