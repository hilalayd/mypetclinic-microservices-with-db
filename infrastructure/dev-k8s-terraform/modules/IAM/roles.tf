resource "aws_iam_policy" "policy_for_master1_role" {
  name        = "policy_for_master_role1"
  policy      = file("./modules/IAM/policy_for_master1.json")
}

resource "aws_iam_policy" "policy_for_worker1_role" {
  name        = "policy_for_worker_role"
  policy      = file("./modules/IAM/policy_for_worker1.json")
}

resource "aws_iam_role" "role_for_master1" {
  name = "role_master1_k8s"

  # Terraform "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "role_for_master1"
  }
}

resource "aws_iam_role" "role_for_worker1" {
  name = "role_worker1_k8s"

  # Terraform "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "role_for_worker1"
  }
}

resource "aws_iam_policy_attachment" "attach_for_master1" {
  name       = "attachment_for_master1"
  roles      = [aws_iam_role.role_for_master1.name]
  policy_arn = aws_iam_policy.policy_for_master1_role.arn
}

resource "aws_iam_policy_attachment" "attach_for_worker1" {
  name       = "attachment_for_worker1"
  roles      = [aws_iam_role.role_for_worker1.name]
  policy_arn = aws_iam_policy.policy_for_worker1_role.arn
}

resource "aws_iam_instance_profile" "profile_for_master1" {
  name  = "profile_for_master1"
  role = aws_iam_role.role_for_master1.name
}

resource "aws_iam_instance_profile" "profile_for_worker1" {
  name  = "profile_for_worker1"
  role = aws_iam_role.role_for_worker1.name
}

output master1_profile_name {
  value       = aws_iam_instance_profile.profile_for_master1.name
}

output worker1_profile_name {
  value       = aws_iam_instance_profile.profile_for_worker1.name
}

