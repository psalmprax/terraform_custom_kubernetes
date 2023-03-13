resource "aws_iam_role" "instance_s3_acces_policy" {
  name = "instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "instance_s3_acces_policy"
  }
}

resource "aws_iam_role_policy_attachment" "instance_s3_acces_policy_attachment" {
  role       = aws_iam_role.instance_s3_acces_policy.name
  policy_arn = aws_iam_policy.s3_acces_policy.arn
}


resource "aws_iam_instance_profile" "instance_s3_acces_profile" {
  name = "instance_s3_acces_profile"
  role = aws_iam_role.instance_s3_acces_policy.name

  tags = {
    Name = "instance_s3_acces_profile"
  }
}