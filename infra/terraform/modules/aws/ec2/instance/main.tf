
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
    protocol  = "TCP"
    self      = true
    from_port = 22
    to_port   = 22
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

resource "aws_instance" "instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3a.large"
  subnet_id     = "${var.subnet}"
  vpc_security_group_ids = [ "${aws_security_group.instance-sg.id}" ]

  user_data = <<EOF
#!/bin/bash
curl -sq https://github.com/raelga.keys | tee -a /home/ubuntu/.ssh/authorized_keys
EOF

  tags = {
    Name    = "${var.name}"
    account = "talks"
  }
} 
