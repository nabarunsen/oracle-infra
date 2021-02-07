# Source from https://registry.terraform.io/modules/oracle-terraform-modules/vcn/oci/

module "vcn"{
  source  = "oracle-terraform-modules/vcn/oci"
  version = "1.0.3"
  # Use the latest version, if there is one newer than "1.0.3"
  # insert the 4 required variables here

  # Required
  compartment_id = oci_identity_compartment.tf-compartment.id
  region = "ap-sydney-1"
  vcn_name = "test-vcn"
  vcn_dns_label = "testvcn"

  # Optional
  internet_gateway_enabled = true
  nat_gateway_enabled = true
  service_gateway_enabled = true
  vcn_cidr = "10.0.0.0/16"
}
