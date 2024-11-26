module "vpc" {
  source           = "../modules/vpc"
  vpc_cidr         = var.vpc_cidr
  name_prefix      = var.name_prefix
  web_subnet_cidrs = var.web_subnet_cidrs
  app_subnet_cidrs = var.app_subnet_cidrs
  db_subnet_cidrs  = var.db_subnet_cidrs
}

# Security Group for Instance
resource "aws_security_group" "instance_sg" {
  name_prefix = "${var.name_prefix}-instance-sg-"
  description = "Enable SSH access via port 22 and allow self-reference traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH IPv4 IN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Self-reference rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-instance-sg"
  }
}

# IAM Role for Session Manager
resource "aws_iam_role" "session_manager_role" {
  name_prefix = "${var.name_prefix}-session-manager-role-"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

# IAM Role Policy for Session Manager
resource "aws_iam_role_policy" "session_manager_policy" {
  name = "session-manager-policy"
  role = aws_iam_role.session_manager_role.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        Resource : "*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "session_manager_instance_profile" {
  name_prefix = "${var.name_prefix}-session-manager-profile-"
  role        = aws_iam_role.session_manager_role.name
}


# EC2 Instance
resource "aws_instance" "instance" {
  ami                    = var.bastion_ami
  instance_type          = "t2.micro"
  subnet_id              = element(module.vpc.app_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.session_manager_instance_profile.name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "${var.name_prefix}-instance"
  }
}

