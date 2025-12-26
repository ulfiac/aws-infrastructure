module "create_aws_lambda" {
  count  = var.create_lambda ? 1 : 0
  source = "./modules/create_aws_lambda"
}

module "create_rds_database" {
  count  = var.create_rds_database ? 1 : 0
  source = "./modules/create_rds_database"
}

module "launch_ec2_instance" {
  count  = var.launch_ec2_instance ? 1 : 0
  source = "./modules/launch_ec2_instance"
}

module "setup_cost_budget" {
  count  = var.setup_cost_budget ? 1 : 0
  source = "./modules/setup_cost_budget"
}

module "use_foundation_model" {
  count  = var.use_foundation_model ? 1 : 0
  source = "./modules/use_foundation_model"
}
