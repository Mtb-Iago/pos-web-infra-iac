variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_session_token" {
  type    = string
  default = null
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = "posweb-myapp-2026"
  vpc_security_group_ids = [aws_security_group.posweb_myapp_2026_sg.id]
  user_data_base64 = base64encode(templatefile("${path.module}/templates/user_data.tpl", {}))

  tags = {
    Name = "HelloWorld2"
  }
}
