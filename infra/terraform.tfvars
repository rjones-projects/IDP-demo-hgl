project_id = "my-project-dev"

# delivery (modules: cloud_build, cloud_build_private_worker_pool)
cloud_build_private_worker_pool = {
  region = "europe-west3"
}

# WARNING: 'region' conflict — was "europe-west2", now "europe-west3" (later value wins).
region                                      = "europe-west3"
bastion_vm                                  = "test"
bastion_vm_default                          = "test"
managed_revision                            = true
type                                        = "SERVICE"
keyring_create                              = true
allow_dns_egress                            = true
allow_github_access                         = true
allow_internal_communication                = true
allow_metadata_server_egress                = true
create_googleapis_dns                       = true
create_nat                                  = true
custom_allow_github_fw_name                 = "egress-allow-vf-github"
custom_allow_internal_communication_fw_name = "egress-allow-internal-commn"
custom_allow_private_google_apis_fw_name    = "allow-private-googleapis-egress"
custom_allow_restricted_google_apis_fw_name = "allow-restricted-googleapis-egress"
custom_deny_egress_fw_name                  = "deny-egress"
deny_egress                                 = false
enable_private_service_connect              = true
export_custom_routes                        = true
export_subnet_routes_with_public_ip         = false
global_address_name                         = "private-ip-address"
googleapis_dns_mode                         = "PRIVATE"
import_custom_routes                        = false
import_subnet_routes_with_public_ip         = false
ingress_health_check                        = true
ingress_ssh_via_IAP                         = true
min_ports_per_vm                            = 64
nat_log_filter                              = "ALL"
nat_source_mode                             = "LIST_OF_SUBNETWORKS"
private_google_apis                         = false
restricted_google_apis                      = false
routing_mode                                = "REGIONAL"
valid_subnet_range                          = "192.168.0.0/16"
