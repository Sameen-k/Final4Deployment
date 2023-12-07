# configure aws provider
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-2"
}
#
#
#
#
#create first instance:default-vpc with jenkins and deadsnakes
resource "aws_instance" "Final4JenkinsManager" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-2a"
  vpc_security_group_ids = ["sg-0ff74dfb5f8df8a73"]
  associate_public_ip_address = true
  key_name = var.key_name

  user_data = "${file("jenkins.sh")}"

  tags = {
    Name : "Final4JenkinsManager_"
  }
}
#
#
#
#
#create second instance:default-vpc with docker, java environment, and deadsnakes
resource "aws_instance" "Final4DockerAgent" {
  provider = aws
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-2b"
  vpc_security_group_ids = ["sg-0ff74dfb5f8df8a73"]
  associate_public_ip_address = true
  key_name = var.key_name

  user_data = "${file("dockeragent2.sh")}"

  tags = {
    Name : "Final4DockerAgent"
  }
}
#


#create third instance:default-vpc with terraform and java environment
resource "aws_instance" "Final4TfAgent" {
  provider = aws
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-2b"
  vpc_security_group_ids = ["sg-0ff74dfb5f8df8a73"]
  associate_public_ip_address = true
  key_name = var.key_name

  user_data = "${file("terraform.sh")}"

  tags = {
    Name : "Final4TfAgent"
  }
}

#
#
#create fourth instance:default-vpc with terraform and java environment
resource "aws_instance" "Final4EKSAgent" {
  provider = aws
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = "us-east-2b"
  vpc_security_group_ids = ["sg-0ff74dfb5f8df8a73"]
  associate_public_ip_address = true
  key_name = var.key_name

  user_data = "${file("eks-jre.sh")}"

  tags = {
    Name : "Final4EKSAgent"
  }
}



output "Jenkins_manager_ip" {
  value = aws_instance.Final4JenkinsManager.public_ip
}

output "Docker_agent_ip" {
  value = aws_instance.Final4DockerAgent.public_ip
}

output "TF_agent_ip" {
  value = aws_instance.Final4TfAgent.public_ip
}

output "EKS_agent_ip" {
  value = aws_instance.Final4EKSAgent.public_ip
}