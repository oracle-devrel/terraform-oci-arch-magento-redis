## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
  availability_domain_name = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
}

data "oci_identity_compartment" "find_compartment" {
    id = var.compartment_ocid
}

module "oci-arch-redis" {
  source                          = "github.com/oracle-devrel/terraform-oci-arch-redis"
  tenancy_ocid                    = var.tenancy_ocid
  user_ocid                       = var.user_ocid
  fingerprint                     = var.fingerprint 
  private_key_path                = var.private_key_path
  region                          = var.region
  compartment_ocid                = var.compartment_ocid
  use_existing_vcn                = true
  vcn_id                          = oci_core_virtual_network.magento_redis_mds_vcn.id
  use_private_subnet              = true 
  redis_subnet_id                 = oci_core_subnet.redis_subnet_private.id
  use_bastion_service             = var.use_bastion_service 
  bastion_server_public_ip        = !var.use_bastion_service ? oci_core_instance.bastion_instance[0].public_ip : ""
  bastion_service_id              = var.use_bastion_service ? oci_bastion_bastion.bastion_service_redis[0].id : ""
  numberOfMasterNodes             = 1
  numberOfReplicaNodes            = 2
  cluster_enabled                 = false
}
