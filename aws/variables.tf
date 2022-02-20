variable "app_port" {
  type    = number
  default = 8080
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "name" {
  default = "go_web_server"
}

variable "image_name" {
  default = "thiago18l/go_web_server"
}

variable "commit" {}