# Region gets set in provider and with subnet AZs
variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "user_data_script" {
  description = "User data script for EC2 instances"
  default = <<-EOT
    #!/bin/sh
    # Docker CE for Linux installation script
    curl -fsSL https://get.docker.com | sh
    # Add the uid=1000 user to "docker" group
    groupadd docker
    usermod -aG docker $(id --user 1000 --name)
    # Start Docker service
    systemctl start docker
    # Run the Docker container
    docker run --rm -p 80:3000 strm/helloworld-http
  EOT
}

variable "ami_img"{
  description = "AMI image for EC2 insstances"
  default = "ami-0c45689cf7ad8a412"
}

variable "ec2_instance_type" {
  description = "Instance type for EC2"
  default = "t3a.micro"
  
}

variable "ec2_key_name" {
  description = "SSH key for EC2 instances"
  default = "andy-ireland"
}