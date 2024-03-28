# IAM role for Elastic Beanstalk service
resource "aws_iam_role" "beanstalk_service_role" {
  name               = "aws-elasticbeanstalk-service-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "elasticbeanstalk.amazonaws.com" },
      Action    = "sts:AssumeRole",
    }],
  })
}
# IAM role for EC2 instances launched by Elastic Beanstalk
resource "aws_iam_role" "beanstalk_ec2_role" {
  name               = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "beanstalk_service_attachment" {
  name       = "beanstalk-service-attachment"
  roles      = [aws_iam_role.beanstalk_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}
resource "aws_iam_policy_attachment" "beanstalk_ec2_attachment" {
  name       = "beanstalk-ec2-attachment"
  roles      = [aws_iam_role.beanstalk_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkCustomPlatformforEC2Role"
}
resource "aws_iam_policy_attachment" "beanstalk_ec2_attachment2" {
  name       = "beanstalk-ec2-attachment2"
  roles      = [aws_iam_role.beanstalk_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "beanstalk_ec2_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}


resource "aws_s3_bucket" "app_code" {
  bucket = "ebs-bucket"
}
resource "aws_s3_object" "node_app" {
  bucket = aws_s3_bucket.app_code.id
  key    = "todo-code.zip"
  source = "/Users/manish/Downloads/mern-todo/todo-code.zip"
}

# Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "delpoy_app" {
  name        = "Application_for_nodejs"
  description = "application for node js"
}
   
resource "aws_elastic_beanstalk_application_version" "application_version" {
  name        = "ebs-application_version"
  application = aws_elastic_beanstalk_application.delpoy_app.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.app_code.id
  key         = aws_s3_object.node_app.id
}

# Elastic Beanstalk environment     
resource "aws_elastic_beanstalk_environment" "NodeEnv" {
  name                = "Node-Env"
  application         = aws_elastic_beanstalk_application.delpoy_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.2 running Node.js 20"
  tier = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnet1_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.name
  }
}
