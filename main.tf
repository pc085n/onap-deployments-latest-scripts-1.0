variable "vault-address" { }
variable "vault-token" { }
variable "node-prefix" { }

provider "vault" {
  address = "${var.vault-address}"
  token = "${var.vault-token}"
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "my-role"
}

provider "aws" {
  region     = "us-east-2"
  access_key = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.creds.secret_key}"
}

resource "aws_instance" "nfs" {
  count         = 1
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.xlarge"
  key_name      = "ohio-key-pair"
  subnet_id     = "subnet-3cfdd447"
  vpc_security_group_ids = ["sg-3296d85a"]
  source_dest_check = true
  associate_public_ip_address = true
  ebs_block_device {
      device_name = "/dev/sda1"
      volume_type = "gp2"
      volume_size = "160"
  }
  tags = {
    Name = "${var.node-prefix}-nfs-${count.index + 1}"
    Type = "nfs"
  }
}

resource "aws_instance" "worker" {
  count         = 3
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "m5a.4xlarge"
  key_name      = "ohio-key-pair"
  subnet_id     = "subnet-3cfdd447"
  vpc_security_group_ids = ["sg-3296d85a"]
  source_dest_check = true
  associate_public_ip_address = true
  ebs_block_device {
      device_name = "/dev/sda1"
      volume_type = "gp2"
      volume_size = "150"
  }  
  tags = {
    Name = "${var.node-prefix}-worker-${count.index + 1}"
    Type = "worker"
  }
}

resource "aws_instance" "control" {
  count         = 3
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.xlarge"
  key_name      = "ohio-key-pair"
  subnet_id     = "subnet-3cfdd447"
  vpc_security_group_ids = ["sg-3296d85a"]
  source_dest_check = true
  associate_public_ip_address = true
  ebs_block_device {
      device_name = "/dev/sda1"
      volume_type = "gp2"
      volume_size = "120"
  }
  tags = {
    Name = "${var.node-prefix}-control-${count.index + 1}"
    Type = "control"
  }
}

