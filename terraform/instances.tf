data "aws_ami" "centos" {
  owners = ["679593333241"]
  most_recent = true
  filter {
    name = "name"
    values = [
      "CentOS Linux 7 x86_64 HVM EBS *"
    ]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpcs" "default" {

}

data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = tolist(data.aws_vpcs.default.ids)[0]
}

resource "aws_instance" "docker_swarm_hosts" {
  count = var.num_swarm_hosts
  ami = data.aws_ami.centos.id
  subnet_id = tolist(data.aws_subnet_ids.vpc_subnets.ids)[count.index]
  key_name = var.key_name
  instance_type = var.instance_size
  security_groups = [aws_security_group.docker_swarm_sg.id]
  provisioner "local-exec" {
    command = "echo ${var.host_types[count.index]} ${self.public_ip} >> hosts_out.txt"
  }
  tags = {
    Name = "Docker Swarm Host ${count.index}"
    CreatedBy = "Terraform"
    Project = "Docker Study"
  }
}

resource "null_resource" "docker_cluster" {
  depends_on = [aws_instance.docker_swarm_hosts]
  provisioner "local-exec" {
    command = "sleep 120 && python ../python/build_inventory.py && ansible-playbook --private-key ${var.private_key_path} -i ../ansible/inventory.ini ../ansible/build_swarm_cluster.yml && rm hosts_out.txt"
  }
}


resource "aws_security_group" "docker_swarm_sg" {
  name = "Docker_Swarm"
  description = "Allow traffic for Docker Swarm hosts"
  vpc_id = tolist(data.aws_vpcs.default.ids)[0]
  ingress {
    description = "Allow traffic between Docker hosts"
    self = true
    from_port = 0
    to_port = 0
    protocol = -1
  }
  ingress {
    description = "Allow SSH access from home"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [var.home_subnet]
  }
  egress {
    description = "Allow traffic between Docker hosts"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
}
