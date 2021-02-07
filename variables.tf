
variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "service_ports" {
  default = [80,443,22,8080]
}
