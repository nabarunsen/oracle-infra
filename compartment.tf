
resource "oci_identity_compartment" "tf-compartment" {
    # Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaf5jculpus7fwf3t7spt7xb2v5amo3xf6ps5qyaduykdxgt6vl5za"
    description = "Compartment for Terraform resources."
    name = "application-compartment"
}
