data "aws_iam_policy_document" "s3_acces_policy_document" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::airsamtest"]
    actions   = ["s3:ListBucket"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::airsamtest/*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:*",
      "cloudtrail:LookupEvents",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["replication.ecr.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:network-interface/*"]
    actions   = ["ec2:CreateTags"]
  }
}


resource "aws_iam_policy" "s3_acces_policy" {
  name   = "example_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_acces_policy_document.json

  tags = {
    Name = "s3_acces_policy"
  }
}