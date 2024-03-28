output "app_name" {
 description = "beanstalk application name"
 value = aws_elastic_beanstalk_application.delpoy_app.name
}

 output "env_name" {
 description = "elastic beanstalk environment name"
 value = aws_elastic_beanstalk_environment.NodeEnv.name
 }