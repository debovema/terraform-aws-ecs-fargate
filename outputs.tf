output "alb_dns_name" {
  value = "${module.alb.alb_dns_name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "alb_target_group_arn" {
  value = "${module.alb.default_target_group_arn}"
}

output "private_subnet_ids" {
  value = ["${module.subnets.private_subnet_ids}"]
}

output "ecs_arn" {
  value = "${var.ecs_enabled == "true" ? element(concat(aws_ecs_cluster.ecs.*.arn, list("")), 0) : ""}"
}