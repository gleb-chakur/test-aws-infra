variable "name" {
  default = "test"
}

variable "environment" {
  default     = "test"
}

variable "region" {
    default     = "eu-central-1"
}

variable "aws-region" {
  type        = string
  default     = "us-east-1"
}

# variable "aws-access-key" {
#   type = string
# }

# variable "aws-secret-key" {
#   type = string
# }



variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "public_subnets" {
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "service_desired_count" {
  default     = 2
}

variable "container_port" {
  default     = 3000
}

variable "container_cpu" {
  default     = 256
}

variable "container_memory" {
  default     = 512
}

variable "health_check_path" {
  default     = "/health"
}

variable "tsl_certificate_arn" {
}
