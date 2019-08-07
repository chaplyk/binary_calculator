provider "aws" {
    region = "eu-west-2"
}

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

resource "aws_key_pair" "bohdan_chaplyk" {
  key_name   = "bohdan_chaplyk"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+c3lOtYXz/n83CJjZg4TRCHdOdR7RlI+Ag1g/sVjh0Z5n58xMl0HXtwkFKGJ0SMwtcCj8XTH2hZ3lWEmiumSJJflIz6ieriqRGhJDgZJY9P3ikdjssmxOKRi9eyxgF7y3gP93vP0K3ZF9hjrVGU24ZeNwy8cGNGMT+R2ipWV41dVQ2oMMnfRjgg0ltxRbr2uH9VOcL8XVowJqhf2STUAr/pqIURtfVSkOktX+Q5kWKKVIQwCrQhcjnQXFt6CxaCfJglSe1ah5m3BvgqR3TI9Zqtw61dZJFKtLxK+SAarnSa1RF1GXyeB/Lrqn2cjz5hsUa7qznI9G8ZoiT2YkBGn3 bohdanchaplyk@ubuntu"
}

resource "aws_security_group" "allow_http" {
name = "allow_http"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_jenkins" {
name = "allow_jenkins"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "flask" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_http.name}"]
  key_name = "${aws_key_pair.bohdan_chaplyk.key_name}"


  tags = {
    Name = "bohdanc_tfl25_flask"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_jenkins.name}"]
  key_name = "${aws_key_pair.bohdan_chaplyk.key_name}"


  tags = {
    Name = "bohdanc_tfl25_jenkins"
  }
}