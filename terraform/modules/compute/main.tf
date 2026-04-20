data "aws_ssm_parameter" "ubuntu_ami" {
  name = var.ami_ssm_parameter
}

resource "aws_instance" "this" {
  for_each = toset(var.instance_names)

  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    instance_name = each.key
  })

  user_data_replace_on_change = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = var.delete_on_termination
    encrypted             = true

    tags = {
      Name = "${each.key}-root"
    }
  }

  tags = {
    Name = each.key
  }
}