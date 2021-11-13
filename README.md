# iac_docker_swarm
This is an example of how Terraform and Ansible can work together to build resources in AWS.
Terraform is used to build and secure some AWS instances.  We then use Ansible to configure
the instances into a Docker Swarm cluster.  A small Python script is used to build an 
Ansible config file.
The entire process is started from Terraform.
