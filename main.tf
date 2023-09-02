locals {
  ingress_rules = concat([
    {
      protocol        = 6
      from_port       = 0
      to_port         = 20200
      cidr_blocks     = "0.0.0.0/0"
      security_groups = null
      self            = true
    },
    ], [
    for r in var.ingress_rules : {
      protocol        = lookup(r, "protocol", 6)
      from_port       = lookup(r, "port", 0)
      to_port         = lookup(r, "port", 20200)
      cidr_blocks     = lookup(r, "cidr_blocks", "0.0.0.0/0")
      security_groups = lookup(r, "security_groups", null)
      self            = false
    }
  ])

  egress_rules = concat([
    {
      protocol        = 6
      from_port       = 0
      to_port         = 20200
      cidr_blocks     = "0.0.0.0/0"
      security_groups = null
    }
    ], [
    for r in var.egress_rules : {
      protocol        = lookup(r, "protocol", 6)
      from_port       = lookup(r, "port", 0)
      to_port         = lookup(r, "port", 20200)
      cidr_blocks     = lookup(r, "cidr_blocks", "0.0.0.0/0")
      security_groups = lookup(r, "security_groups", null)
    }
  ])
}

resource "oci_core_network_security_group" "ocisecuritygroup" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  vcn_id         = var.vcn_id
}

resource "oci_core_network_security_group_security_rule" "ocisecuritygroupingress" {
  count                  = length(local.ingress_rules)
  rule            = tolist(local.ingress_rules)[count.index]
  network_security_group_id = oci_core_network_security_group.ocisecuritygroup.id
  direction                 = "INGRESS"
  protocol                  = rule.protocol
  source                    = rule.cidr_blocks
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range {
      max = rule.to_port
      min = rule.from_port
    }
    source_port_range {
      max = rule.to_port
      min = rule.from_port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ocisecuritygroupegress" {
  count                  = length(local.egress_rules)
  rule            = tolist(local.egress_rules)[count.index]
  network_security_group_id = oci_core_network_security_group.ocisecuritygroup.id
  direction                 = "EGRESS"
  protocol                  = rule.protocol
  source                    = rule.cidr_blocks
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range {
      max = rule.to_port
      min = rule.from_port
    }
    source_port_range {
      max = rule.to_port
      min = role.from_port
    }
  }
}