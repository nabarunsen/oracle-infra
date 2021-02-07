

resource "oci_core_instance" "bostion_host" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = oci_identity_compartment.tf-compartment.id
    shape = "VM.Standard.E2.1"
    source_details {
        source_id = "ocid1.image.oc1.ap-sydney-1.aaaaaaaauegdu6hjrepwgsahccdreys7bbcutd3ntqwqobhsigc3yl23oupq"
        source_type = "image"
    }

    # Optional
    display_name = "bostion_host"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.vcn-public-subnet.id
    }
    metadata = {
        ssh_authorized_keys = file("/Users/nabarun/tf-simple-infrastructure/test-compute-key.pub")
    } 
    preserve_boot_volume = false

}

resource "oci_core_instance" "application_host" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = oci_identity_compartment.tf-compartment.id
    shape = "VM.Standard.E2.1"
    source_details {
        source_id = "ocid1.image.oc1.ap-sydney-1.aaaaaaaauegdu6hjrepwgsahccdreys7bbcutd3ntqwqobhsigc3yl23oupq"
        source_type = "image"
    }

    # Optional
    display_name = "application_host"
    create_vnic_details {
        assign_public_ip = false
        subnet_id = oci_core_subnet.vcn-private-subnet.id
    }
    metadata = {
        ssh_authorized_keys = file("/Users/nabarun/tf-simple-infrastructure/test-compute-key.pub")
		user_data = "${base64encode(file("bootstrap.sh"))}"
    }
    preserve_boot_volume = false
}
