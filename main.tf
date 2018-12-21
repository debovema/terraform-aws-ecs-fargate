data "aws_availability_zones" "available" {
  state      = "available"
}

data "aws_region" "current" {}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"

  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

module "vpc" {
  source    = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.3.5"

  namespace = "${module.label.namespace}"
  stage     = "${module.label.stage}"
  name      = "${module.label.name}"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.3.8"

  namespace           = "${module.label.namespace}"
  stage               = "${module.label.stage}"
  name                = "${module.label.name}"

  region              = "${data.aws_region.current.name}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"

  cidr_block          = "10.0.0.0/16"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.az_count)}"]
}

module "alb" {
  source                           = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.2.6"

  namespace                        = "${module.label.namespace}"
  stage                            = "${module.label.stage}"
  name                             = "${module.label.name}"

  vpc_id                           = "${module.vpc.vpc_id}"
  ip_address_type                  = "ipv4"
  http_port                        = "${var.alb_http_port}"

  subnet_ids                       = ["${module.subnets.public_subnet_ids}"]
  access_logs_region               = "${data.aws_region.current.name}"

  health_check_unhealthy_threshold = "${var.alb_health_check_unhealthy_threshold}"
  health_check_interval            = "${var.alb_health_check_interval}"
}

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = "${module.label.name}"

  tags = {
    Environment = "${module.label.stage}"
    Application = "${module.label.name}"
  }
}
