variable "region" {
  description = "AWS region to deploy"
  default     = "ap-south-1"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  default     = "SingleInstanceKeyPair"
}

variable "ssh_cidr" {
  description = "Allowed SSH access range"
  default     = "0.0.0.0/0"
}

# Ubuntu 22.04 LTS AMI for ap-south-1 (Mumbai)
# You can change region if needed
variable "ubuntu_ami" {
  default = "ami-02d26659fd82cf299"
}
