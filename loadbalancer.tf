resource "oci_load_balancer" "AppLoadBalancer" {
  shape          = "100Mbps"
  compartment_id = oci_identity_compartment.tf-compartment.id 
  subnet_ids     = [ 
    oci_core_subnet.vcn-public-subnet.id
  ]
  display_name   = "AppLoadBalancer"
}

resource "oci_load_balancer_backendset" "AppLoadBalancerBackendset" {
  name             = "AppLBBackendset"
  load_balancer_id = oci_load_balancer.AppLoadBalancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "80"
    protocol = "HTTP"
    response_body_regex = ".*"
    url_path = "/"
  }
}


resource "oci_load_balancer_listener" "AppLoadBalancerListener" {
  load_balancer_id         = oci_load_balancer.AppLoadBalancer.id
  name                     = "AppLoadBalancerListener"
  default_backend_set_name = oci_load_balancer_backendset.AppLoadBalancerBackendset.name
  port                     = 80
  protocol                 = "HTTP"
}


resource "oci_load_balancer_backend" "AppLoadBalancerBackend" {
  load_balancer_id = oci_load_balancer.AppLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.AppLoadBalancerBackendset.name
  ip_address       = oci_core_instance.application_host.private_ip
  port             = 8080
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_core_security_list" "AppSecurityList" {
    compartment_id = oci_identity_compartment.tf-compartment.id 
    display_name = "AppSecurityList"
    vcn_id = module.vcn.vcn_id
    
    egress_security_rules {
        protocol = "6"
        destination = "0.0.0.0/0"
    }
    
    dynamic "ingress_security_rules" {
    for_each = var.service_ports
    content {
        protocol = "6"
        source = "0.0.0.0/0"
        tcp_options {
            max = ingress_security_rules.value
            min = ingress_security_rules.value
            }
        }
    }

    ingress_security_rules {
        protocol = "6"
        source = "10.0.0.0/16"
    }
}
