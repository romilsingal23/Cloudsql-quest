# Module Definition: Cloud SQL
module "cloud_sql" {
  source                       = "./cloud_sql" # Replace with your module path
  project                      = var.project
  instance_id                  = var.instance_id
  database_version             = var.database_version
  region                       = var.region
  zone_availability            = var.zone_availability
  machine_tier                 = var.machine_tier
  storage_type                 = var.storage_type
  storage_capacity             = var.storage_capacity
  enable_automated_backups     = var.enable_automated_backups
  backup_window_start          = var.backup_window_start
  enable_point_in_time_recovery = var.enable_point_in_time_recovery
  log_retention_days           = var.log_retention_days
  network                      = var.network
  kms_key_name                 = var.kms_key_name
  enable_deletion_protection   = var.enable_deletion_protection
  user_name                    = var.user_name
  password                     = var.password
}

# Resources for Cloud SQL
resource "google_sql_database_instance" "default" {
  project          = var.project
  name             = var.instance_id
  database_version = var.database_version
  region           = var.region

  settings {
    tier                       = var.machine_tier
    availability_type          = var.zone_availability
    storage_type               = var.storage_type
    storage_size_gb            = var.storage_capacity
    activation_policy          = "ALWAYS"

    backup_configuration {
      enabled                  = var.enable_automated_backups
      start_time               = var.backup_window_start
      point_in_time_recovery_enabled = var.enable_point_in_time_recovery
    }

    ip_configuration {
      private_network          = var.network
    }

    disk_encryption_configuration {
      kms_key_name             = var.kms_key_name
    }

    database_flags {
      name  = "log_retention_days"
      value = tostring(var.log_retention_days)
    }
  }

  deletion_protection = var.enable_deletion_protection
}

resource "google_sql_user" "default" {
  project  = var.project
  instance = google_sql_database_instance.default.name
  name     = var.user_name
  password = var.password
}

# Variables
variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "instance_id" {
  description = "The Cloud SQL instance ID"
  type        = string
}

variable "database_version" {
  description = "The Cloud SQL database version"
  type        = string
}

variable "region" {
  description = "The region for the Cloud SQL instance"
  type        = string
}

variable "zone_availability" {
  description = "The availability type (SINGLE_ZONE or REGIONAL)"
  type        = string
}

variable "machine_tier" {
  description = "The machine configuration tier (e.g., db-custom-4-16384)"
  type        = string
}

variable "storage_type" {
  description = "Storage type (SSD or HDD)"
  type        = string
}

variable "storage_capacity" {
  description = "The storage capacity in GB"
  type        = number
}

variable "enable_automated_backups" {
  description = "Enable automated backups"
  type        = bool
}

variable "backup_window_start" {
  description = "Start time for the backup window (e.g., 09:00)"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery"
  type        = bool
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
}

variable "network" {
  description = "The VPC network name for private IP"
  type        = string
}

variable "kms_key_name" {
  description = "The KMS key for disk encryption"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the instance"
  type        = bool
}

variable "user_name" {
  description = "Database username"
  type        = string
}

variable "password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Outputs
output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = google_sql_database_instance.default.name
}

output "connection_name" {
  description = "The connection name of the instance"
  value       = google_sql_database_instance.default.connection_name
}

output "database_user" {
  description = "The database username"
  value       = google_sql_user.default.name
}
