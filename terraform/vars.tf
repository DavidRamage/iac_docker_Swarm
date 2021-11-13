variable "num_swarm_hosts" {
  type = number
  default = 3
}

variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "key_name" {
  type = string
}

variable "home_subnet" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "instance_size" {
  type = string
  default = "t3.micro"
}

variable "host_types" {
  type = list(string)
  default = [
    "manager",
    "worker",
    "worker"
  ]
}
