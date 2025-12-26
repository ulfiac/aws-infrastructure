locals {
  availability_zones = sort([for subnet in data.aws_subnet.default : subnet.availability_zone])
}

resource "aws_db_subnet_group" "aurora_serverless_v2" {
  subnet_ids = data.aws_subnets.default.ids
}

#trivy:ignore:AVD-AWS-0077 (MEDIUM): Cluster instance has very low backup retention period
#trivy:ignore:AVD-AWS-0343 (MEDIUM): Cluster does not have Deletion Protection enabled
resource "aws_rds_cluster" "aurora_serverless_v2" {
  availability_zones            = local.availability_zones
  db_subnet_group_name          = aws_db_subnet_group.aurora_serverless_v2.name
  engine                        = "aurora-postgresql"
  engine_mode                   = "provisioned"
  engine_version                = "15.10" # LTS
  kms_key_id                    = data.aws_kms_key.rds.arn
  manage_master_user_password   = true
  master_username               = "postgres"
  master_user_secret_kms_key_id = data.aws_kms_key.secrets_manager.arn
  skip_final_snapshot           = true
  storage_encrypted             = true
  storage_type                  = "aurora-iopt1"
  vpc_security_group_ids        = [data.aws_security_group.default.id]

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 4
  }
}

#trivy:ignore:AVD-AWS-0133 (LOW): Instance does not have performance insights enabled
resource "aws_rds_cluster_instance" "aurora_serverless_v2" {
  cluster_identifier = aws_rds_cluster.aurora_serverless_v2.cluster_identifier
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_serverless_v2.engine
  engine_version     = aws_rds_cluster.aurora_serverless_v2.engine_version
}
