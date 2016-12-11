resource "aws_security_group" "byovpn" {
  name = "byovpn.security group"
  description = "Allow VPN traffic"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 500
    to_port = 500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 500
    to_port = 500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4500
    to_port = 4500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "byovpn" {
  key_name = "byovpn"
  public_key = "${file("id_rsa.pub")}"
}

resource "aws_instance" "byovpn" {
  ami             = "${lookup(var.amis, var.region)}"
  instance_type   = "t2.nano"
  security_groups = ["${aws_security_group.byovpn.name}"]
  key_name        = "${aws_key_pair.byovpn.key_name}"

  tags {
    Name = "byovpn"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("id_rsa")}"
  }

  provisioner "file" {
    source = "provisioning.sh"
    destination = "/tmp/provisioning.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "cat > /tmp/terraform_config <<EOF",
      "export IPSEC_PSK=${var.vpn_phrase}",
      "export VPN_USER=${var.vpn_user}",
      "export VPN_PASSWORD=${var.vpn_password}",
      "EOF",

      "chmod +x /tmp/provisioning.sh",
      "chmod +x /tmp/terraform_config",
      "sudo /tmp/provisioning.sh"
    ]
  }
}

output "ip" {
    value = "${aws_instance.byovpn.public_ip}"
}
