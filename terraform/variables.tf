variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "ami_id" {
  default = "ami-0f918f7e67a3323f0" # Ubuntu
}

variable "instance_type" {
  default = "t2.micro"
}
