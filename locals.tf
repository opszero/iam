
locals {
  partition = data.aws_partition.current.partition
}

data "aws_partition" "current" {}
