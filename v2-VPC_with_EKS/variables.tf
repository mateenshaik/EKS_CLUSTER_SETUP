variable "region" {

    default = "us-east-2"
  
}

variable "os_name" {

    default = "ami-024e6efaf93d85776"
  
}

variable "instance_type" {

    default = "t2.micro"  
}

variable "key" {
    default = "Jenkins_reagian" 
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "subnet1_cidr" {
    default = "10.10.1.0/24"
  
}

variable "subnet2_cidr" {
    default = "10.10.2.0/24"
  
}



variable "subnet_az" {
  default = "us-east-2a"
}

variable "subnet_2_az" {
  default = "us-east-2b"
}