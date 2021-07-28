provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "dbserver" {
  ami = "ami-03ac5a9b225e99b02"
  instance_type = "t2.micro"
  tags = {
    "Name" = "DBServer"
  }

}

resource "aws_instance" "webserver" {
  ami = "ami-03ac5a9b225e99b02"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg.name]
  user_data = file("server_script.sh")
  tags = {
    "Name" = "WebServer"
  }
}



resource "aws_eip" "EIP" {
    instance = aws_instance.webserver.id
}

output "EIP" {
    value = aws_eip.EIP.public_ip
}

output "PIP" {
    value = aws_instance.dbserver.private_ip      
}


variable "ingressrules" {
  type = list(string)
  default = [ 443,80 ]
}

variable "egressrules" {
  type = list(string)
  default = [ 443,80 ]
}




resource "aws_security_group" "sg" {
  name = "ALLOW HTTPHTTPS"

    dynamic "ingress"  {
      iterator = port
      for_each = var.ingressrules
      content{
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "value"
      from_port = port.value
      ipv6_cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "TCP"
      to_port = port.value
    } 
    }

    dynamic "egress" {
      iterator = port
      for_each = var.egressrules
      content{
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "value"
      from_port = port.value
      ipv6_cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "TCP"
      to_port = port.value
    } 
    }
}
