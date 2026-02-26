variable "region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "age-calculator"

}
variable "container_port" {
  default = 80
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "512"
}

