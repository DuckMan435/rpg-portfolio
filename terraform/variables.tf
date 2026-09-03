variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "rpg_db"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "forge"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "rpg-vpc"
}