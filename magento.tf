## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-arch-magento" {
  source                          = "github.com/oracle-devrel/terraform-oci-arch-magento"
  tenancy_ocid                    = var.tenancy_ocid
  vcn_id                          = oci_core_virtual_network.magento_redis_mds_vcn.id
  numberOfNodes                   = var.numberOfMagentoNodes
  availability_domain_name        = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  compartment_ocid                = var.compartment_ocid
  image_id                        = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  shape                           = var.node_shape
  label_prefix                    = var.label_prefix
  mds_ip                          = module.mds-instance.mysql_db_system.ip_address
  magento_subnet_id               = oci_core_subnet.magento_subnet.id
  lb_subnet_id                    = oci_core_subnet.lb_subnet_public.id
  bastion_subnet_id               = !var.use_bastion_service ? oci_core_subnet.bastion_subnet_public.id : ""
  fss_subnet_id                   = oci_core_subnet.fss_subnet_private.id 
  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  magento_schema                  = var.magento_schema
  magento_name                    = var.magento_name
  magento_password                = var.magento_password
  magento_admin_password          = var.magento_admin_password
  magento_admin_email             = var.magento_admin_email
  magento_backend_frontname       = var.magento_backend_frontname
  display_name                    = var.magento_instance_name
  flex_shape_ocpus                = var.node_flex_shape_ocpus
  flex_shape_memory               = var.node_flex_shape_memory
  lb_shape                        = var.lb_shape 
  flex_lb_min_shape               = var.flex_lb_min_shape 
  flex_lb_max_shape               = var.flex_lb_max_shape 
  use_bastion_service             = var.use_bastion_service 
  inject_bastion_service_id       = var.use_bastion_service 
  inject_bastion_server_public_ip = !var.use_bastion_service 
  bastion_server_public_ip        = !var.use_bastion_service ? oci_core_instance.bastion_instance[0].public_ip : ""
  bastion_service_id              = var.use_bastion_service ? oci_bastion_bastion.bastion_service_magento[0].id : ""
  bastion_service_region          = var.use_bastion_service ? var.region : ""
  use_redis_cache                 = var.use_redis_cache
  use_redis_as_session_storage    = var.use_redis_as_session_storage
  use_redis_as_cache_backend      = var.use_redis_as_cache_backend 
  use_redis_as_page_cache         = var.use_redis_as_page_cache
  redis_ip_address                = module.oci-arch-redis.redis-masters_private_ips[0]
  redis_password                  = module.oci-arch-redis.redis_password
  defined_tags                    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}