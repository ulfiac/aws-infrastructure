data "aws_ami" "most_recent_al2023" {
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

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.most_recent_al2023.id
  associate_public_ip_address = false
  ebs_optimized               = true
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [data.aws_security_group.default.id]

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
