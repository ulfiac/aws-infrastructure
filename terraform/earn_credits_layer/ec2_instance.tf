data "aws_ami" "billing_credit" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.8.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "billing_credit" {
  ami                         = data.aws_ami.billing_credit.id
  associate_public_ip_address = false
  ebs_optimized               = true
  instance_type               = "t3.micro"

  metadata_options {
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_key.ebs.arn
    volume_type           = "gp3"
  }
}
