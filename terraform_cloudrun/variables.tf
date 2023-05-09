variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "zone" {
  type    = string
  default = "europe-west4-c"
}


variable "app_version" {
  type    = string
  default = "Version 0"
}

variable "colour" {
  type    = string
  default = "red"
}
