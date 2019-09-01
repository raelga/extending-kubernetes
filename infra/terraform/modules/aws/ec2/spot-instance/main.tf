
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "instance-sg" {
  vpc_id = "${var.vpc}"

  ingress {
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.name}-sg"
    account = "talks"
  }
}

resource "aws_spot_instance_request" "instance" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet}"
  vpc_security_group_ids = ["${aws_security_group.instance-sg.id}"]

  spot_price                      = "${var.spot_price}"
  wait_for_fulfillment            = true
  instance_interruption_behaviour = "stop"

  user_data = <<EOF
#!/bin/bash
# User configuration
usermod -l ${var.system_user} -d /home/${var.system_user} -m ${var.system_default_user} && groupmod -n ${var.system_user} ${var.system_default_user};
echo "${var.system_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-cloud-init-users
curl -sq https://github.com/${var.github_user}.keys | tee -a /home/${var.system_user}/.ssh/authorized_keys
# Package installation
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get install -y docker-ce git golang-go
sudo usermod -aG docker ${var.system_user}
EOF

  # Tagging still doesn't work for spot instances
  # https://github.com/terraform-providers/terraform-provider-aws/issues/32
  tags = {
    Name    = "${var.name}"
    account = "talks"
  }
}
