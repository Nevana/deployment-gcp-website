terraform {
  backend "gcs" {
    bucket = "123456765432123451"
    prefix = "terraform/"
  }
}
