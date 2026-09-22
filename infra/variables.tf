variable "project_id" {
  description = "The GCP project ID."
  type        = string
  default     = ""

  # NOTE: No upstream default — set this before applying.
}

variable "region" {
  description = "The GCP region for resources."
  type        = string
  default     = "us-central1"
}

variable "allow_dns_egress" {
  description = "Allow egress traffic to DNS servers (port 53)"
  type        = bool
  default     = true
}

variable "allow_github_access" {
  description = "If true, creates a firewall rule to allow egress traffic to Vodafone GitHub IPs on port 443."
  type        = bool
  default     = true
}

variable "allow_internal_communication" {
  description = "Value for allow_internal_communication."
  type        = bool
  default     = true
}

variable "allow_metadata_server_egress" {
  description = "Allow egress to GCP Metadata server (169.254.169.254)"
  type        = bool
  default     = true
}

variable "bastion_vm" {
  description = "Bastion VM configurations"
  type        = any
  default     = {}
}

variable "bastion_vm_default" {
  description = "A bastion vm object to be merged into"
  type        = object({
    name                             = string
    machine_type                     = string
    zone                             = string
    metadata                         = map(any)
    labels                           = map(string)
    tags                             = list(string)
    bastion_image_id                 = string
    disk_size                        = string
    disk_kms_key                     = string
    sa_email                         = string
    network                          = string
    subnetwork                       = string
    enable_secure_boot               = bool
    enable_integrity_monitoring      = bool
    deletion_protection              = bool
    enable_vtpm                      = bool
    resource_policies                = list(string)
    iap_users                        = list(any)
    bastion_ssh_target_firewall_flag = bool
    management_zone_name             = string
    management_zone_cidr             = string
    ssh_authorized_service_accounts  = list(string)
  })
  default     = {
    name         = null
    machine_type = "n1-standard-1"
    zone         = null
    metadata = {
      enable-oslogin         = "true"
      enable_mysql           = "false"
      block-project-ssh-keys = "TRUE"
    }
    labels                           = {}
    tags                             = []
    bastion_image_id                 = null
    disk_size                        = "50"
    disk_kms_key                     = null
    sa_email                         = null
    network                          = null
    subnetwork                       = null
    enable_secure_boot               = true
    enable_integrity_monitoring      = true
    deletion_protection              = false
    enable_vtpm                      = false
    resource_policies                = []
    iap_users                        = []
    bastion_ssh_target_firewall_flag = false
    management_zone_name             = null
    management_zone_cidr             = null
    ssh_authorized_service_accounts  = []
  }
}

variable "bigquery" {
  description = "BigQuery config with specs"
  type        = any
  default     = ""
}

variable "bigquery_table" {
  description = "BigQuery table config with specs"
  type        = any
  default     = ""
}

variable "bucket_default" {
  description = "A bucket object to be merged into."
  type        = object({
    bucket_name                 = string
    location                    = string
    storage_class               = string
    uniform_bucket_level_access = bool
    kms_key_name                = string
    labels                      = map(string)
    versioning_enabled          = bool
    public_access_prevention    = string
    accesses = list(object({
      role    = string
      members = list(string)
    }))
    retention_policy = object({
      is_locked        = bool
      retention_period = number
    })
    logging = object({
      log_bucket        = string
      log_object_prefix = string
    })
    lifecycle_rules = list(object({
      action = map(string)
      condition = object({
        age                   = number
        with_state            = string
        created_before        = string
        matches_storage_class = list(string)
        num_newer_versions    = number
      })
    }))
    autoclass = bool
    iam_bindings = map(object({
      members = list(string)
      role    = string
      condition = optional(object({
        expression  = string
        title       = string
        description = optional(string)
      }))

    }))
    iam_bindings_additive = map(object({
      member = string
      role   = string
      condition = optional(object({
        expression  = string
        title       = string
        description = optional(string)
      }))
    }))
    objects_to_upload = map(object({
      name           = string
      source         = optional(string)
      detect_md5hash = optional(string)
    }))
  })
  default     = {
    bucket_name                 = null
    location                    = null
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true
    kms_key_name                = null
    labels                      = {}
    versioning_enabled          = true
    public_access_prevention    = "enforced"
    accesses                    = []
    retention_policy            = null
    logging                     = null
    lifecycle_rules             = []
    autoclass                   = true
    iam_bindings                = {}
    iam_bindings_additive       = {}
    objects_to_upload           = {}
  }
}

variable "cloud_build" {
  description = "Cloud build object"
  type        = any
  default     = null

  # NOTE: No upstream default — set this before applying.
}

variable "cloud_build_default" {
  description = "Default Cloud Build object to merge into"
  type        = object({
    name        = string
    location    = string
    annotations = map(string)
    connection_config = object({
      github = optional(object({
        app_installation_id                  = optional(string)
        authorizer_credential_secret_version = optional(string)
      }))
      github_enterprise = optional(object({
        app_id                        = optional(string)
        app_installation_id           = optional(string)
        app_slug                      = optional(string)
        host_uri                      = string
        private_key_secret_version    = optional(string)
        service                       = optional(string)
        ssl_ca                        = optional(string)
        webhook_secret_secret_version = optional(string)
      }))
    })
    connection_create = bool
    disabled          = bool
    repositories = map(object({
      remote_uri  = string
      annotations = optional(map(string), {})
      triggers = optional(map(object({
        approval_required = optional(bool, false)
        description       = optional(string)
        pull_request = optional(object({
          branch          = optional(string)
          invert_regex    = optional(string)
          comment_control = optional(string)
        }))
        push = optional(object({
          branch       = optional(string)
          invert_regex = optional(string)
          tag          = optional(string)
        }))
        disabled           = optional(bool, false)
        filename           = string
        include_build_logs = optional(string)
        substitutions      = optional(map(string), {})
        service_account    = optional(string)
        tags               = optional(list(string), [])
      })), {})
    }))
    iam = map(list(string))
    iam_bindings_additive = map(object({
      member = string
      role   = string
    }))

  })
  default     = {
    name                  = null
    location              = null
    annotations           = {}
    connection_config     = {}
    connection_create     = true
    disabled              = false
    repositories          = {}
    iam                   = {}
    iam_bindings_additive = {}
  }
}

variable "cloud_build_private_worker_pool" {
  description = "Cloud build private worker pool configurations"
  type        = any
  default     = {}
}

variable "cloud_build_private_worker_pool_default" {
  description = "A private worker pool to be merged into"
  type        = object({
    name   = string
    region = string
    worker_config = object({
      disk_size_gb                 = optional(number)
      machine_type                 = optional(string)
      no_external_ip               = optional(bool)
      enable_nested_virtualisation = optional(bool)
    })
    network_config = object({
      peered_network          = optional(string)
      peered_network_ip_range = optional(string)
    })
  })
  default     = {
    name           = null
    region         = null
    worker_config  = null
    network_config = null
  }
}

variable "cloud_run" {
  description = "Cloud Run configuration object passed from project.yaml. Expected to contain a 'spec' field with a list of definitions."
  type        = any
  default     = {
    spec = []
  }
}

variable "cloud_sql" {
  description = "Cloud SQL configurations"
  type        = any
  default     = {}
}

variable "cloud_sql_default" {
  description = "A cloud SQL object to be merged into"
  type        = object({
    name                = string
    database_version    = string
    deletion_protection = bool
    encryption_key_name = string
    tier                = string
    disk_size           = number
    disk_type           = string
    availability_type   = string
    labels              = map(string)
    flags               = map(string)
    backup_configuration = object({
      enabled                        = bool
      start_time                     = optional(string)
      location                       = optional(string)
      point_in_time_recovery_enabled = optional(bool)
      transaction_log_retention_days = optional(number)
      retained_backups               = optional(number)
      retention_unit                 = optional(string)
    })
    enable_private_service_access                 = bool
    network_link                                  = string
    enable_private_path_for_google_cloud_services = bool
    ssl_mode                                      = string
    psc_enabled                                   = bool
    psc_allowed_consumer_projects                 = list(string)
    databases                                     = list(string)
    read_replicas = list(object({
      name                = string
      tier                = string
      zone                = string
      disk_type           = string
      disk_size           = number
      labels              = map(string)
      database_flags      = map(string)
      ip_configuration    = map(string)
      encryption_key_name = string
    }))
    random_instance_name  = bool
    secret_access_members = list(string)
  })
  default     = {
    name                = ""
    database_version    = "MYSQL_8_0"
    deletion_protection = true
    encryption_key_name = null
    tier                = "db-f1-micro"
    disk_size           = 10
    disk_type           = "PD_SSD"
    availability_type   = "ZONAL"
    labels              = {}
    flags               = {}
    backup_configuration = {
      enabled                        = false
      start_time                     = "03:00"
      location                       = null
      point_in_time_recovery_enabled = false
      transaction_log_retention_days = null
      retained_backups               = null
      retention_unit                 = "COUNT"
    }
    enable_private_service_access                 = true
    network_link                                  = null
    enable_private_path_for_google_cloud_services = false
    ssl_mode                                      = "ENCRYPTED_ONLY"
    psc_enabled                                   = false
    psc_allowed_consumer_projects                 = []
    databases                                     = []
    read_replicas                                 = []
    random_instance_name                          = true
    secret_access_members                         = []
  }
}

variable "common_resource_id" {
  description = "A common string to use as a prefix for resource names. If not provided, the project name is used."
  type        = string
  default     = null
}

variable "composer_environment" {
  description = "Composer environment configurations"
  type        = any
  default     = {}
}

variable "composer_environment_default" {
  description = "A composer environment to be merged into"
  type        = object({
    name                             = string
    labels                           = map(string)
    tags                             = set(string)
    network                          = string
    network_project_id               = string
    subnetwork                       = string
    subnetwork_region                = string
    use_existing_network_attachment  = bool
    composer_network_attachment_name = string
    composer_service_account         = string
    airflow_config_overrides         = map(string)
    env_variables                    = map(string)
    image_version                    = string
    web_server_plugins_mode          = string
    pypi_packages                    = map(string)
    use_private_environment          = bool
    enable_private_builds_only       = bool
    maintenance_start_time           = string
    maintenance_end_time             = string
    maintenance_recurrence           = string
    environment_size                 = string
    scheduler = object({
      cpu        = string
      memory_gb  = number
      storage_gb = number
      count      = number
    })
    web_server = object({
      cpu        = string
      memory_gb  = number
      storage_gb = number
    })
    worker = object({
      cpu        = string
      memory_gb  = number
      storage_gb = number
      min_count  = number
      max_count  = number
    })
    triggerer = object({
      cpu       = string
      memory_gb = number
      count     = number
    })
    dag_processor = object({
      cpu        = string
      memory_gb  = number
      storage_gb = number
      count      = number
    })
    grant_sa_agent_permission = bool
    scheduled_snapshots_config = object({
      enabled                    = optional(bool)
      snapshot_location          = optional(string)
      snapshot_creation_schedule = optional(string)
      time_zone                  = optional(string)
    })
    storage_bucket                 = string
    resilience_mode                = string
    cloud_data_lineage_integration = bool
    web_server_network_access_control = list(object({
      allowed_ip_range = string
      description      = string
    }))
    kms_key_name                     = string
    task_logs_retention_storage_mode = string
  })
  default     = {
    name                             = null
    labels                           = {}
    tags                             = []
    network                          = null
    network_project_id               = null
    subnetwork                       = null
    subnetwork_region                = null
    use_existing_network_attachment  = true
    composer_network_attachment_name = null
    composer_service_account         = null
    airflow_config_overrides         = {}
    env_variables                    = {}
    image_version                    = "composer-3-airflow-2.10.2-build.7"
    web_server_plugins_mode          = "ENABLED"
    pypi_packages                    = {}
    use_private_environment          = true
    enable_private_builds_only       = true
    maintenance_start_time           = "05:00"
    maintenance_end_time             = null
    maintenance_recurrence           = null
    environment_size                 = "ENVIRONMENT_SIZE_MEDIUM"
    scheduler = {
      cpu        = 0.5
      memory_gb  = 1
      storage_gb = 1
      count      = 1
    }
    web_server = {
      cpu        = 0.5
      memory_gb  = 2
      storage_gb = 1
    }
    worker = {
      cpu        = 0.5
      memory_gb  = 1
      storage_gb = 1
      min_count  = 2
      max_count  = 3
    }
    triggerer = {
      cpu       = 1
      memory_gb = 1
      count     = 1
    }
    dag_processor = {
      cpu        = 0.5
      memory_gb  = 1
      storage_gb = 1
      count      = 1
    }
    grant_sa_agent_permission         = true
    scheduled_snapshots_config        = null
    storage_bucket                    = null
    resilience_mode                   = null
    cloud_data_lineage_integration    = false
    web_server_network_access_control = null
    kms_key_name                      = null
    task_logs_retention_storage_mode  = null
  }
}

variable "containers" {
  description = "Containers in name => attributes format."
  type        = map(object({
    image      = string
    depends_on = optional(list(string))
    command    = optional(list(string))
    args       = optional(list(string))
    env        = optional(map(string))
    env_from_key = optional(map(object({
      secret  = string
      version = string
    })))
    liveness_probe = optional(object({
      grpc = optional(object({
        port    = optional(number)
        service = optional(string)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string)
        port         = optional(number)
      }))
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      timeout_seconds       = optional(number)
    }))
    ports = optional(map(object({
      container_port = optional(number)
      name           = optional(string)
    })))
    resources = optional(object({
      limits            = optional(map(string))
      cpu_idle          = optional(bool)
      startup_cpu_boost = optional(bool)
    }))
    startup_probe = optional(object({
      grpc = optional(object({
        port    = optional(number)
        service = optional(string)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string)
        port         = optional(number)
      }))
      tcp_socket = optional(object({
        port = optional(number)
      }))
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      timeout_seconds       = optional(number)
    }))
    volume_mounts = optional(map(string))
  }))
  default     = {}
}

variable "containers_default" {
  description = "default values for containers to be merged into"
  type        = object({
    image      = string
    depends_on = optional(list(string))
    command    = optional(list(string))
    args       = optional(list(string))
    env        = optional(map(string))
    env_from_key = optional(map(object({
      secret  = string
      version = string
    })))
    liveness_probe = optional(object({
      grpc = optional(object({
        port    = optional(number, null)
        service = optional(string, null)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string, null)
        port         = optional(number, null)
      }))
      failure_threshold     = optional(number, null)
      initial_delay_seconds = optional(number, null)
      period_seconds        = optional(number, null)
      timeout_seconds       = optional(number, null)
    }))
    ports = optional(map(object({
      container_port = optional(number, null)
      name           = optional(string, null)
    })))
    resources = optional(object({
      limits            = optional(map(string))
      cpu_idle          = optional(bool, null)
      startup_cpu_boost = optional(bool, null)
    }))
    startup_probe = optional(object({
      grpc = optional(object({
        port    = optional(number, null)
        service = optional(string, null)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string, null)
        port         = optional(number, null)
      }))
      tcp_socket = optional(object({
        port = optional(number, null)
      }))
      failure_threshold     = optional(number, null)
      initial_delay_seconds = optional(number, null)
      period_seconds        = optional(number, null)
      timeout_seconds       = optional(number, null)
    }))
    volume_mounts = optional(map(string))
  })
  default     = {
    image = null
  }
}

variable "context" {
  description = "Context-specific interpolations."
  type        = object({
    condition_vars = optional(map(map(string)), {}) # not needed here?
    cidr_ranges    = optional(map(string), {})
    custom_roles   = optional(map(string), {})
    iam_principals = optional(map(string), {})
    kms_keys       = optional(map(string), {})
    locations      = optional(map(string), {})
    networks       = optional(map(string), {})
    project_ids    = optional(map(string), {})
    subnets        = optional(map(string), {})
    tag_values     = optional(map(string), {})
  })
  default     = {}
}

variable "create_googleapis_dns" {
  description = "Create Cloud DNS private zones for googleapis.com, gcr.io, and pkg.dev"
  type        = bool
  default     = true
}

variable "create_nat" {
  description = "If false, do not create Cloud NAT or NAT external IPs."
  type        = bool
  default     = true
}

variable "custom_allow_github_fw_name" {
  description = "Value for custom_allow_github_fw_name."
  type        = string
  default     = "egress-allow-vf-github"
}

variable "custom_allow_internal_communication_fw_name" {
  description = "Value for custom_allow_internal_communication_fw_name."
  type        = string
  default     = "egress-allow-internal-commn"
}

variable "custom_allow_private_google_apis_fw_name" {
  description = "Value for custom_allow_private_google_apis_fw_name."
  type        = string
  default     = "allow-private-googleapis-egress"
}

variable "custom_allow_restricted_google_apis_fw_name" {
  description = "Value for custom_allow_restricted_google_apis_fw_name."
  type        = string
  default     = "allow-restricted-googleapis-egress"
}

variable "custom_deny_egress_fw_name" {
  description = "Value for custom_deny_egress_fw_name."
  type        = string
  default     = "deny-egress"
}

variable "custom_nat_ip_desc" {
  description = "A custom description for the Cloud NAT external IP address."
  type        = string
  default     = ""
}

variable "custom_nat_ip_name" {
  description = "A custom name for the Cloud NAT external IP address. If not provided, a name will be generated."
  type        = string
  default     = ""
}

variable "custom_nat_name" {
  description = "A custom name for the Cloud NAT gateway. If not provided, a name will be generated."
  type        = string
  default     = ""
}

variable "custom_router_name" {
  description = "A custom name for the Cloud Router. If not provided, a name will be generated."
  type        = string
  default     = ""
}

variable "custom_vpc_name" {
  description = "A custom name for the VPC network. If not provided, a name will be generated."
  type        = string
  default     = ""
}

variable "dataset_default" {
  description = "A dataset object to be merged into"
  type        = object({
    friendly_name               = optional(string)
    description                 = optional(string)
    location                    = optional(string)
    delete_contents_on_destroy  = optional(string)
    default_table_expiration_ms = optional(number)
    cmek_key_name               = optional(string)
    iam = optional(object({
      owners = optional(object({
        groups           = optional(list(string))
        service_accounts = optional(list(string))
        special_groups   = optional(list(string))
        users            = optional(list(string))
      }))
      writers = optional(object({
        groups           = optional(list(string))
        service_accounts = optional(list(string))
        special_groups   = optional(list(string))
        users            = optional(list(string))
      }))
      readers = optional(object({
        groups           = optional(list(string))
        service_accounts = optional(list(string))
        special_groups   = optional(list(string))
        users            = optional(list(string))
      }))
      users = optional(object({
        groups           = optional(list(string))
        service_accounts = optional(list(string))
        special_groups   = optional(list(string))
        users            = optional(list(string))
      }))
      metadata_viewers = optional(object({
        groups           = optional(list(string))
        service_accounts = optional(list(string))
        special_groups   = optional(list(string))
        users            = optional(list(string))
      }))
    }))
  })
  default     = {
    friendly_name               = null
    description                 = null
    location                    = "EU"
    delete_contents_on_destroy  = false
    default_table_expiration_ms = 3600000
    cmek_key_name               = null
    iam                         = {}
  }
}

variable "default_rules_config" {
  description = "Optionally created convenience rules. Set the 'disabled' attribute to true, or individual rule attributes to empty lists to disable."
  type        = object({
    admin_ranges = optional(list(string))
    disabled     = optional(bool, false)
    http_ranges = optional(list(string), [
      "35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
    )
    http_tags = optional(list(string), ["http-server"])
    https_ranges = optional(list(string), [
      "35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
    )
    https_tags = optional(list(string), ["https-server"])
    ssh_ranges = optional(list(string), ["35.235.240.0/20"])
    ssh_tags   = optional(list(string), ["ssh"])
  })
  default     = {}
}

variable "deletion_protection" {
  description = "Deletion protection setting for this Cloud Run service."
  type        = string
  default     = null
}

variable "deny_egress" {
  description = "Warning: Deny egress to 0.0.0.0/0 does not work with transparent Squid."
  type        = bool
  default     = false
}

variable "description" {
  description = "Description for the VPC network."
  type        = string
  default     = null
}

variable "dns" {
  description = "DNS config with specs"
  type        = any
  default     = ""
}

variable "dns_default" {
  description = "A dns object to be merged into"
  type        = object({
    name = string
    zone_config = object({
      domain = string
      forwarding = optional(object({
        forwarders      = optional(map(string))
        client_networks = list(string)
      }))
      peering = optional(object({
        client_networks = list(string)
        peer_network    = string
      }))
      public = optional(object({
        dnssec_config = optional(object({
          non_existence = optional(string)
          state         = string
          key_signing_key = optional(object(
            { algorithm = string, key_length = number })
          )
          zone_signing_key = optional(object(
            { algorithm = string, key_length = number })
          )
        }))
        enable_logging = optional(bool)
      }))
      private = optional(object({
        client_networks             = list(string)
        service_directory_namespace = optional(string)
        reverse_managed             = optional(bool)
      }))
    })
    description   = string
    force_destroy = bool
    iam           = map(list(string))
    recordsets = map(object({
      ttl     = optional(number)
      records = optional(list(string))
      geo_routing = optional(list(object({
        location = string
        records  = optional(list(string))
        health_checked_targets = optional(list(object({
          load_balancer_type = string
          ip_address         = string
          port               = string
          ip_protocol        = string
          network_url        = string
          project            = string
          region             = optional(string)
        })))
      })))
      wrr_routing = optional(list(object({
        weight  = number
        records = list(string)
      })))
    }))
    labels = map(string)
  })
  default     = {
    name = null
    zone_config = {
      domain = null
    }
    description   = null
    force_destroy = false
    iam           = {}
    recordsets    = {}
    labels        = {}
  }
}

variable "egress_rules" {
  description = "List of egress rule definitions, default to deny action. Null destination ranges will be replaced with 0/0."
  type        = map(object({
    deny               = optional(bool, true)
    description        = optional(string)
    destination_ranges = optional(list(string))
    destination_fqdns  = optional(list(string)) # Added
    disabled           = optional(bool, false)
    enable_logging = optional(object({
      include_metadata = optional(bool)
    }))
    priority             = optional(number, 1000)
    source_ranges        = optional(list(string))
    source_fqdns         = optional(list(string)) # Added
    targets              = optional(list(string))
    use_service_accounts = optional(bool, false)
    rules = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [{ protocol = "all" }])
  }))
  default     = {}
}

variable "enable_private_service_connect" {
  description = "Value for enable_private_service_connect."
  type        = bool
  default     = true
}

variable "encryption_key" {
  description = "The full resource name of the Cloud KMS CryptoKey."
  type        = string
  default     = null
}

variable "export_custom_routes" {
  description = "Export custom routes on the servicenetworking peering (PSC). Set true when peered networks need custom route export."
  type        = bool
  default     = true
}

variable "export_subnet_routes_with_public_ip" {
  description = "Export subnet routes with public IP on the servicenetworking peering (PSC)."
  type        = bool
  default     = false
}

variable "external_global_address" {
  description = "External global address configuration from project.yaml. Must contain a 'spec' list of address definitions."
  type        = any
  default     = {
    spec = []
  }
}

variable "external_global_loadbalancer" {
  description = "External global load balancer configuration from project.yaml. Must contain a 'spec' list of load balancer definitions."
  type        = any
  default     = {
    spec = []
  }
}

variable "external_subnets_allows_nats" {
  description = "A list of subnetworks allowed for NAT configuration."
  type        = list(object({
    self_link = string
  }))
  default     = []
}

variable "factories_config" {
  description = "Paths to data files and folders that enable factory functionality."
  type        = object({
    cidr_tpl_file = optional(string)
    rules_folder  = optional(string)
  })
  default     = {}
}

variable "firewall" {
  description = "Firewall module config with spec."
  type        = any
  default     = null
}

variable "gcs" {
  description = "GCS config with specification."
  type        = any
  default     = null
}

variable "global_address_name" {
  description = "The name of the global internal address for Private Service Connect."
  type        = string
  default     = "private-ip-address"
}

variable "googleapis_dns_mode" {
  description = "Which VIP to use for googleapis.com: RESTRICTED (199.36.153.4/30) or PRIVATE (199.36.153.8/30)"
  type        = string
  default     = "PRIVATE"
}

variable "iam" {
  description = "IAM bindings for Cloud Run service in {ROLE => [MEMBERS]} format."
  type        = map(list(string))
  default     = {}
}

variable "iam_bindings" {
  description = "Authoritative IAM bindings in {KEY => {role = ROLE, members = [], condition = {}}}. Keys are arbitrary."
  type        = map(object({
    members = list(string)
    role    = string
    condition = optional(object({
      expression  = string
      title       = string
      description = optional(string)
    }))
  }))
  default     = {}
}

variable "iam_bindings_additive" {
  description = "Keyring individual additive IAM bindings. Keys are arbitrary."
  type        = map(object({
    member = string
    role   = string
    condition = optional(object({
      expression  = string
      title       = string
      description = optional(string)
    }))
  }))
  default     = {}
}

variable "iam_custom_role_stack" {
  description = "iam_custom_role_stack object"
  type        = any
  default     = null
}

variable "iam_custom_role_stack_default" {
  description = "A iam_custom_role_stack object to be merged into"
  type        = object({
    target_project_ids     = set(string)
    role_id                = string
    title                  = string
    description            = string
    core_permissions_count = number
    resolve_base_roles     = bool
    base_roles             = list(string)
    additional_permissions = list(string)
    excluded_permissions   = list(string)
    members                = list(string)
    stage                  = string
  })
  default     = {
    target_project_ids     = []
    role_id                = null
    title                  = ""
    description            = ""
    core_permissions_count = 1500
    resolve_base_roles     = true
    base_roles = [
      "roles/bigquery.admin",
      "roles/cloudbuild.admin",
      "roles/cloudfunctions.admin",
      "roles/composer.admin",
      "roles/compute.admin",
      "roles/container.admin",
      "roles/dataform.admin",
      "roles/dataproc.admin",
      "roles/dns.admin",
      "roles/run.admin",
      "roles/compute.networkAdmin",
      "roles/iam.serviceAccountAdmin",
      "roles/cloudkms.admin",
      "roles/logging.admin",
      "roles/monitoring.admin",
      "roles/pubsub.admin",
      "roles/secretmanager.admin",
      "roles/cloudsql.admin",
      "roles/storage.admin",
      "roles/iam.admin"
    ]
    additional_permissions = []
    excluded_permissions = [
      "compute.firewallPolicies.copyRules",
      "compute.firewallPolicies.move",
      "compute.securityPolicies.copyRules",
      "compute.securityPolicies.move",
      "compute.orgRolloutPlans.create",
      "compute.orgRolloutPlans.delete",
      "compute.orgRolloutPlans.get",
      "compute.orgRolloutPlans.list",
      "compute.orgRolloutPlans.update",
      "compute.orgRolloutPlans.use",
      "compute.orgRolloutPlans.view",
      "compute.orgRolloutPlans.viewAuditTrail",
      "compute.orgRollouts.cancel",
      "compute.orgRollouts.create",
      "compute.orgRollouts.delete",
      "compute.orgRollouts.get",
      "compute.orgRollouts.list",
      "compute.orgRollouts.update",
      "compute.orgRollouts.use",
      "compute.orgRollouts.view",
      "compute.orgRollouts.viewAuditTrail",
      "compute.orgRollouts.pause",
      "compute.orgRollouts.resume",
      "compute.orgRollouts.rollback",
      "compute.orgRollouts.start",
      "compute.orgRollouts.stop",
      "compute.orgRollouts.suspend",
      "compute.orgRollouts.unpause",
      "compute.orgRollouts.unroll",
      "compute.orgRollouts.unsuspend",
      "compute.orgRollouts.unstop",
      "stackdriver.projects.edit",
      "resourcemanager.projects.list",
      "servicenetworking.services.deletePeering",
      "compute.securityPolicies.removeAssociation",
      "eventarc.multiProjectSources.collectGoogleApiEvents",
      "compute.securityPolicies.addAssociation",
      "compute.oslogin.updateExternalUser",
      "iam.googleapis.com/workforcePoolProviderKeys.create",
      "iam.googleapis.com/workforcePoolProviderKeys.delete",
      "iam.googleapis.com/workforcePoolProviderKeys.get",
      "iam.googleapis.com/workforcePoolProviderKeys.list",
      "iam.googleapis.com/workforcePoolProviderKeys.undelete",
      "iam.googleapis.com/workforcePoolProviderScimGroups.create",
      "iam.googleapis.com/workforcePoolProviderScimGroups.delete",
      "iam.googleapis.com/workforcePoolProviderScimGroups.get",
      "iam.googleapis.com/workforcePoolProviderScimGroups.list",
      "iam.googleapis.com/workforcePoolProviderScimGroups.patch",
      "iam.googleapis.com/workforcePoolProviderScimGroups.put",
      "iam.googleapis.com/workforcePoolProviderScimUsers.create",
      "iam.googleapis.com/workforcePoolProviderScimUsers.delete",
      "iam.googleapis.com/workforcePoolProviderScimUsers.get",
      "iam.googleapis.com/workforcePoolProviderScimUsers.list",
      "iam.googleapis.com/workforcePoolProviderScimUsers.patch",
      "iam.googleapis.com/workforcePoolProviderScimUsers.put",
      "iam.googleapis.com/workforcePoolProviders.computeUserAttributes",
      "iam.googleapis.com/workforcePoolProviders.create",
      "iam.googleapis.com/workforcePoolProviders.delete",
      "iam.googleapis.com/workforcePoolProviders.get",
      "iam.googleapis.com/workforcePoolProviders.list",
      "iam.googleapis.com/workforcePoolProviders.undelete",
      "iam.googleapis.com/workforcePoolProviders.update",
      "iam.googleapis.com/workforcePoolSubjects.delete",
      "iam.googleapis.com/workforcePoolSubjects.undelete",
      "iam.googleapis.com/workforcePools.create",
      "iam.googleapis.com/workforcePools.createPolicyBinding",
      "iam.googleapis.com/workforcePools.delete",
      "iam.googleapis.com/workforcePools.deletePolicyBinding",
      "iam.googleapis.com/workforcePools.get",
      "iam.googleapis.com/workforcePools.getIamPolicy",
      "iam.googleapis.com/workforcePools.list",
      "iam.googleapis.com/workforcePools.searchPolicyBindings",
      "iam.googleapis.com/workforcePools.setIamPolicy",
      "iam.googleapis.com/workforcePools.undelete",
      "iam.googleapis.com/workforcePools.update",
      "iam.googleapis.com/workforcePools.updatePolicyBinding",
      "iam.googleapis.com/workspacePools.createPolicyBinding",
      "iam.googleapis.com/workspacePools.deletePolicyBinding",
      "iam.googleapis.com/workspacePools.searchPolicyBindings",
      "iam.googleapis.com/workspacePools.updatePolicyBinding"
    ]
    members = []
    stage   = "GA"
  }
}

variable "iam_service_account" {
  description = "Service account config with items"
  type        = object({
    spec = optional(list(object({
      project_id                 = optional(string)
      name                       = optional(string)
      display_name               = optional(string)
      description                = optional(string)
      prefix                     = optional(string)
      service_account_reuse      = optional(bool)
      tag_bindings               = optional(map(string))
      iam_bindings               = optional(map(list(string)))
      iam_billing_roles          = optional(map(list(string)))
      iam_by_principles_additive = optional(map(list(string)))
      iam_by_principles          = optional(map(list(string)))
      iam_folder_roles           = optional(map(list(string)))
      iam_organization_roles     = optional(map(list(string)))
      iam_project_roles          = optional(list(string))
      iam_sa_roles               = optional(map(list(string)))
      iam_storage_roles          = optional(map(list(string)))
    })), [])
  })
  default     = null
}

variable "import_custom_routes" {
  description = "Import custom routes on the servicenetworking peering (PSC)."
  type        = bool
  default     = false
}

variable "import_job" {
  description = "Keyring import job attributes."
  type        = object({
    id               = string
    import_method    = string
    protection_level = string
  })
  default     = null
}

variable "import_subnet_routes_with_public_ip" {
  description = "Import subnet routes with public IP on the servicenetworking peering (PSC)."
  type        = bool
  default     = false
}

variable "ingress_health_check" {
  description = "If true, creates a firewall rule to allow ingress traffic from Google Cloud health checkers."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "List of ingress rule definitions, default to allow action. Null source ranges will be replaced with 0/0."
  type        = map(object({
    deny               = optional(bool, false)
    description        = optional(string)
    destination_ranges = optional(list(string), [])
    destination_fqdns  = optional(list(string)) # Added
    disabled           = optional(bool, false)
    enable_logging = optional(object({
      include_metadata = optional(bool)
    }))
    priority             = optional(number, 1000)
    source_ranges        = optional(list(string))
    source_fqdns         = optional(list(string)) # Added
    sources              = optional(list(string))
    targets              = optional(list(string))
    use_service_accounts = optional(bool, false)
    rules = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [{ protocol = "all" }])
  }))
  default     = {}
}

variable "ingress_ssh_via_IAP" {
  description = "If true, creates a firewall rule to allow SSH ingress traffic via Google Cloud's Identity-Aware Proxy."
  type        = bool
  default     = true
}

variable "job_config" {
  description = "Cloud Run Job specific configuration."
  type        = object({
    max_retries = optional(number)
    task_count  = optional(number)
    timeout     = optional(string)
  })
  default     = {}
}

variable "keyring" {
  description = "Keyring attributes."
  type        = object({
    location = string
    name     = string
  })
  default     = null
}

variable "keyring_create" {
  description = "Set to false to manage keys and IAM bindings in an existing keyring."
  type        = bool
  default     = true
}

variable "keys" {
  description = "Key names and base attributes. Set attributes to null if not needed."
  type        = map(object({
    destroy_scheduled_duration    = optional(string, null)
    rotation_period               = optional(string, null)
    labels                        = optional(map(string), {})
    finops_resource_type          = optional(string, null)
    purpose                       = optional(string, "ENCRYPT_DECRYPT")
    skip_initial_version_creation = optional(bool, false)
    version_template = optional(object({
      algorithm        = string
      protection_level = optional(string, "SOFTWARE")
    }), null)
    iam = optional(map(list(string)), {})
    iam_bindings = optional(map(object({
      members = list(string)
      role    = string
      condition = optional(object({
        expression  = string
        title       = string
        description = optional(string)
      }), null)
    })), {})
    iam_bindings_additive = optional(map(object({
      member = string
      role   = string
      condition = optional(object({
        expression  = string
        title       = string
        description = optional(string)
      }), null)
    })), {})
  }))
  default     = {}
}

variable "kms" {
  description = "KMS module config with spec."
  type        = any
  default     = null
}

variable "labels" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}

variable "launch_stage" {
  description = "The launch stage as defined by Google Cloud Platform Launch Stages."
  type        = string
  default     = null
}

variable "managed_revision" {
  description = "Whether the Terraform module should control the deployment of revisions."
  type        = bool
  default     = true
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports per VM"
  type        = number
  default     = 64
}

variable "name" {
  description = "Name used for Cloud Run service."
  type        = string
  default     = null
}

variable "named_ranges" {
  description = "Define mapping of names to ranges that can be used in custom rules."
  type        = map(list(string))
  default     = {
    any            = ["0.0.0.0/0"]
    dns-forwarders = ["35.199.192.0/19"]
    health-checkers = [
      "35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"
    ]
    iap-forwarders        = ["35.235.240.0/20"]
    private-googleapis    = ["199.36.153.8/30"]
    restricted-googleapis = ["199.36.153.4/30"]
    rfc1918               = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
}

variable "nat_external_ip_links" {
  description = "List of existing static IP self_links to use for Cloud NAT. If provided, nat_external_ips (creation) will be ignored."
  type        = list(string)
  default     = []
}

variable "nat_external_ips" {
  description = "Value for nat_external_ips."
  type        = list(object({
    name        = string
    description = string
    region      = string
  }))
  default     = []
}

variable "nat_log_filter" {
  description = "Options are ERRORS_ONLY, TRANSLATIONS_ONLY, ALL. Default value is ALL"
  type        = string
  default     = "ALL"
}

variable "nat_source_mode" {
  description = "Valid values are: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, and LIST_OF_SUBNETWORKS. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat#source_subnetwork_ip_ranges_to_nat"
  type        = string
  default     = "LIST_OF_SUBNETWORKS"
}

variable "network" {
  description = "Network module config with spec."
  type        = any
  default     = null
}

variable "private_google_apis" {
  description = "Allow egress to IP ranges for restricted.googleapis.com."
  type        = bool
  default     = false
}

variable "private_service_connect_cidr" {
  description = "Value for private_service_connect_cidr."
  type        = string
  default     = null
}

variable "project_iam" {
  description = "Group-centric IAM config. Expects 'spec' list with 'email' and 'roles'."
  type        = any
  default     = null
}

variable "project_iam_default" {
  description = "Default settings for group items."
  type        = object({
    email = string
    roles = list(string)
    condition = object({
      title       = string
      description = string
      expression  = string
    })
  })
  default     = {
    email     = null
    roles     = []
    condition = null
  }
}

variable "project_number" {
  description = "Project number of var.project_id. Set this to avoid permadiffs when creating tag bindings. This can be left null when reusing service accounts and tags are not used."
  type        = string
  default     = null
}

variable "pubsub" {
  description = "Pub/Sub config with specification."
  type        = any
  default     = {
    spec = []
  }
}

variable "restricted_google_apis" {
  description = "Allow egress to IP ranges for restricted.googleapis.com."
  type        = bool
  default     = false
}

variable "revision" {
  description = "Revision template configurations."
  type        = object({
    gpu_zonal_redundancy_disabled = optional(bool)
    labels                        = optional(map(string))
    name                          = optional(string)
    node_selector = optional(object({
      accelerator = string
    }))
    vpc_access = optional(object({
      connector = optional(string)
      egress    = optional(string, "PRIVATE_RANGES_ONLY")
      network   = optional(string)
      subnet    = optional(string)
      tags      = optional(list(string))
    }), {})
    timeout = optional(string)
    # deprecated fields
    gen2_execution_environment = optional(any) # DEPRECATED
    job                        = optional(any) # DEPRECATED
    max_concurrency            = optional(any) # DEPRECATED
    max_instance_count         = optional(any) # DEPRECATED
    min_instance_count         = optional(any) # DEPRECATED
  })
  default     = {}
}

variable "routing_mode" {
  description = "Routing mode for the VPC network."
  type        = string
  default     = "REGIONAL"
}

variable "service_account_default" {
  description = "A service account object to be merged into"
  type        = object({
    name                       = string
    display_name               = string
    description                = string
    prefix                     = string
    service_account_reuse      = bool
    tag_bindings               = map(string)
    iam_bindings               = map(list(string))
    iam_billing_roles          = map(list(string))
    iam_by_principles_additive = map(list(string))
    iam_by_principles          = map(list(string))
    iam_folder_roles           = map(list(string))
    iam_organization_roles     = map(list(string))
    iam_project_roles          = list(string)
    iam_sa_roles               = map(list(string))
    iam_storage_roles          = map(list(string))
  })
  default     = {
    name                       = null
    display_name               = "Terraform-managed"
    description                = null
    prefix                     = null
    service_account_reuse      = false
    tag_bindings               = {}
    iam_bindings               = {}
    iam_billing_roles          = {}
    iam_by_principles_additive = {}
    iam_by_principles          = {}
    iam_folder_roles           = {}
    iam_organization_roles     = {}
    iam_project_roles          = []
    iam_sa_roles               = {}
    iam_storage_roles          = {}
  }
}

variable "service_agent_iam" {
  description = "Service Agent IAM config. Expects a 'spec' list with 'service' and 'roles'."
  type        = any
  default     = null
}

variable "service_config" {
  description = "Cloud Run service specific configuration options."
  type        = object({
    custom_audiences = optional(list(string), null)
    eventarc_triggers = optional(
      object({
        audit_log = optional(map(object({
          method  = string
          service = string
        })))
        pubsub = optional(map(string))
        storage = optional(map(object({
          bucket = string
          path   = optional(string)
        })))
        service_account_email = optional(string)
    }), {})
    gen2_execution_environment = optional(bool, false)
    iap_config = optional(object({
      iam          = optional(list(string), [])
      iam_additive = optional(list(string), [])
    }), null)
    ingress              = optional(string, "INGRESS_TRAFFIC_ALL")
    invoker_iam_disabled = optional(bool, false)
    max_concurrency      = optional(number)
    scaling = optional(object({
      max_instance_count = optional(number)
      min_instance_count = optional(number)
    }))
    timeout = optional(string)
  })
  default     = {}
}

variable "subnets" {
  description = "A list of subnet objects to create in the VPC. If not provided, a default 'public' and 'private' subnet will be created."
  type        = any
  default     = null
}

variable "subscription_default" {
  description = "A subscription object to be merged into."
  type        = object({
    name                         = string
    ack_deadline_seconds         = number
    message_retention_duration   = string
    retain_acked_messages        = bool
    filter                       = string
    enable_message_ordering      = bool
    enable_exactly_once_delivery = bool
    expiration_policy_ttl        = string
    bigquery                     = any
    cloud_storage                = any
    dead_letter_policy           = any
    push                         = any
    retry_policy                 = any
    finops_resource_type         = string
    labels                       = map(string)
  })
  default     = {
    name                         = null
    ack_deadline_seconds         = null
    message_retention_duration   = null
    retain_acked_messages        = false
    filter                       = null
    enable_message_ordering      = false
    enable_exactly_once_delivery = false
    expiration_policy_ttl        = null
    bigquery                     = null
    cloud_storage                = null
    dead_letter_policy           = null
    push                         = null
    retry_policy                 = null
    finops_resource_type         = "pubsub"
    labels                       = {}
  }
}

variable "table_default" {
  description = "A dataset object to be merged into"
  type        = object({
    dataset_id          = string
    description         = string
    schema              = string # A JSON string or path to a JSON file
    clustering          = optional(list(string))
    deletion_protection = bool
    kms_key_name        = string
    time_partitioning = optional(object({
      type          = string # "DAY", "HOUR", "MONTH", "YEAR"
      field         = optional(string)
      expiration_ms = optional(number)
    }))
    labels = map(string)
  })
  default     = {
    dataset_id          = ""
    description         = null
    schema              = null
    clustering          = []
    deletion_protection = true
    kms_key_name        = null
    time_partitioning = {
      type          = null
      field         = null
      expiration_ms = 0
    }
    labels = {}

  }
}

variable "tag_bindings" {
  description = "Tag bindings for this service, in key => tag value id format."
  type        = map(string)
  default     = {}
}

variable "topic_default" {
  description = "A topic object to be merged into."
  type        = object({
    topic_name                 = string
    ignore_creation            = bool
    project_id                 = string
    kms_key_name               = string
    message_retention_duration = string
    regions                    = list(string)
    finops_resource_type       = string
    labels                     = map(string)
    schema                     = any
    subscriptions              = list(any)
    notifications              = list(any)
    iam_bindings               = map(list(string))
  })
  default     = {
    topic_name                 = null
    ignore_creation            = false
    project_id                 = null
    kms_key_name               = null
    message_retention_duration = null
    regions                    = []
    finops_resource_type       = "pubsub"
    labels                     = {}
    schema                     = null
    subscriptions              = []
    notifications              = []
    iam_bindings               = {}
  }
}

variable "type" {
  description = "Type of Cloud Run resource to deploy: JOB, SERVICE or WORKERPOOL."
  type        = string
  default     = "SERVICE"
}

variable "valid_subnet_range" {
  description = "Value for valid_subnet_range."
  type        = string
  default     = "192.168.0.0/16"
}

variable "vf_security_policy" {
  description = "VF security policy configurations"
  type        = any
  default     = {}
}

variable "vf_security_policy_default" {
  description = "A VF security policy object to be merged into"
  type        = object({
    name                         = string
    description                  = string
    type                         = string
    enable_layer_7_ddos_defense  = bool
    layer_7_ddos_rule_visibility = string
    default_rule_action          = string
    enable_waf                   = bool
    waf_components = list(object({
      expression  = string
      description = string
    }))
    enable_custom_rules = bool
    custom_waf_components = list(object({
      action      = string
      expression  = string
      description = string
    }))
    authorised_networks = list(object({
      cidr_ranges = list(string)
      description = string
    }))
    additional_networks = list(object({
      cidr_ranges = list(string)
      description = string
    }))
    custom_rules = list(object({
      priority      = number
      action        = string
      description   = optional(string)
      preview       = optional(bool, false)
      expression    = optional(string, "")
      src_ip_ranges = optional(list(string), ["*"])
    }))
    enable_ssl_policy = bool
    ssl_policy_name   = string
  })
  default     = {
    name                         = null
    description                  = "Cloud Armor security policy"
    type                         = "CLOUD_ARMOR"
    enable_layer_7_ddos_defense  = false
    layer_7_ddos_rule_visibility = "STANDARD"
    default_rule_action          = "deny(404)"
    enable_waf                   = false
    waf_components = [
      {
        description = "SQL injection",
        expression  = "sqli-stable",
      },
      {
        description = "Cross-site scripting",
        expression  = "xss-stable",
      },
      {
        description = "Local file inclusion",
        expression  = "lfi-stable",
      },
      {
        description = "Remote file inclusion",
        expression  = "rfi-stable",
      },
      {
        description = "Remote code execution",
        expression  = "rce-stable",
      },
      {
        description = "Method enforcement",
        expression  = "methodenforcement-stable",
      },
      {
        description = "Scanner detection",
        expression  = "scannerdetection-stable",
      },
      {
        description = "Protocol attack",
        expression  = "protocolattack-stable",
      },
      {
        description = "PHP injection attack",
        expression  = "php-stable",
      },
      {
        description = "Session fixation attack",
        expression  = "sessionfixation-stable",
      },
      {
        description = "Apache Log4J CVE-2021-44228 vulnerability",
        expression  = "cve-canary",
      },
    ]
    enable_custom_rules   = false
    custom_waf_components = []
    authorised_networks = [
      {
        description = "GDC",
        cidr_ranges = ["200.10.10.10/32", "195.233.26.86/32", "195.233.250.6/32"],
      },
      {
        description = "Portugal offices",
        cidr_ranges = ["212.18.162.33/32", "213.30.78.168/30", "213.30.78.172/32"],
      },
      {
        description = "UK offices",
        cidr_ranges = ["195.233.26.80/28", "85.205.122.128/28", "185.69.146.224/29", "185.69.146.240/29", "85.115.52.0/24", "85.115.53.0/24", "85.115.54.0/24", "195.89.11.0/25", "194.62.232.0/24"]

      },
      {
        description = "India offices 1",
        cidr_ranges = ["121.200.57.84/32", "121.200.57.13/32", "121.200.57.14/32", "121.200.57.85/32"],
      },
      {
        description = "Spain offices",
        cidr_ranges = ["212.166.209.18/32", "62.87.30.66/32"],
      },
      {
        description = "Italy offices",
        cidr_ranges = ["195.232.147.116/30", "195.232.147.120/31"],
      },
      {
        description = "Hungary offices CRQ000030213407",
        cidr_ranges = ["80.244.96.53/32"],
      },
      {
        description = "Romania offices CRQ000030265158 1",
        cidr_ranges = ["46.97.128.35/32", "81.12.134.18/32", "81.12.134.70/32", "81.12.134.71/32", "81.12.134.72/32"],
      },
      {
        description = "Ireland offices CRQ000030284048",
        cidr_ranges = ["213.233.159.69/32"],
      },

      {
        description = "Office Proxies of VOIS Egypt",
        cidr_ranges = ["62.68.247.20/32", "102.221.68.0/22", "102.221.70.4/32"],
      },
      {
        description = "Allow Greece Offices",
        cidr_ranges = ["213.249.56.36/32"]
      }
    ]
    additional_networks = []
    custom_rules        = []
    enable_ssl_policy   = true
    ssl_policy_name     = "strict-ssl-policy"
  }
}

variable "volumes" {
  description = "Named volumes in containers in name => attributes format."
  type        = map(object({
    secret = optional(object({
      name         = string
      default_mode = optional(string)
      path         = optional(string)
      version      = optional(string)
      mode         = optional(string)
    }))
    cloud_sql_instances = optional(list(string))
    empty_dir_size      = optional(string)
    gcs = optional(object({
      # needs revision.gen2_execution_environment
      bucket       = string
      is_read_only = optional(bool)
    }))
    nfs = optional(object({
      server       = string
      path         = optional(string)
      is_read_only = optional(bool)
    }))
  }))
  default     = {}
}

variable "vpc_connector" {
  description = "VPC Access Connector configuration object passed from YAML. Must contain a 'spec' field with a list of connector definitions."
  type        = any
  default     = {
    spec = []
  }
}

variable "workerpool_config" {
  description = "Cloud Run Worker Pool specific configuration."
  type        = object({
    scaling = optional(object({
      manual_instance_count = optional(number)
      max_instance_count    = optional(number)
      min_instance_count    = optional(number)
      mode                  = optional(string)
    }))
  })
  default     = {}
}

variable "workload_identity" {
  description = "Workload identity config with spec list from project.yaml."
  type        = any
  default     = null
}
