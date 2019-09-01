
data "terraform_remote_state" "aws_network" {
  backend = "s3"
  config = {
    region         = "eu-west-1"
    key            = "aws-network"
    bucket         = "tf-state-talks"
    dynamodb_table = "tf-state-talks-locks"
  }
}

module "ec2" {
  source = "../../modules/aws/ec2/instance"
  name = "sandbox"
  vpc = "${data.terraform_remote_state.aws_network.outputs.vpc_id}"
  subnet = "${data.terraform_remote_state.aws_network.outputs.subnet_az1_id}"
}