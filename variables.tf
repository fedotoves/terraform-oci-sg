variable "display_name" {
  default = "Security Rules"
  type = string
}

variable "description" {
  default = "Security Rules for the VCN"
  type = string
}

variable "compartment_id" {
  default = "ocid1.tenancy.oc1..aaaaaaaakumtdvn73ytm5xuoo4fryo3h55jxurqh4nkvhjtca3qbyw5ih2la"
  type = string
}

variable "vcn_id" {
  type = string
}

variable "ingress_rules" {
  default = []
  description = "A list of custom ingress rules to apply"
  type = any
}

variable "egress_rules" {
  default = []
  description = "A list of custom egress rules to apply"
  type = any
}