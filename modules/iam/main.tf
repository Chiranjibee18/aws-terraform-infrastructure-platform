resource "aws_iam_role" "ec2" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ec2-ssm-role"
    Environment = var.environment
  }
}

# Attach AWS Systems Manager (SSM) policy for secure, keyless terminal access
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2.name
}
