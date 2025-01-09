module "cloud_sql" {
  source                       = "./cloud_sql"
  project                      = "prj-cus-qaw-dev-66576"
  instance_id                  = "qaw-app-db-dev"
  database_version             = "POSTGRES_16"
  region                       = "us-east4"
  zone_availability            = "SINGLE_ZONE"
  machine_tier                 = "db-custom-4-16384"
  storage_type                 = "SSD"
  storage_capacity             = 100
  enable_automated_backups     = true
  backup_window_start          = "09:00"
  enable_point_in_time_recovery = true
  log_retention_days           = 7
  network                      = "projects/prj-shrd-ntwk-3/global/networks/vpc-non-prod-shared-host"
  kms_key_name                 = "projects/prj-key-mgt-dev/locations/us-east4/keyRings/qadp/cryptoKeys/cloudsql"
  enable_deletion_protection   = true
  user_name                    = "admin"
  password                     = "qaw-app-db-dev-password"
}