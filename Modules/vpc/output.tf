output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.krishna.id

}
output "subnet1_id" {
  description = "subnet1 id cidr" 
  value = aws_subnet.subnet1.id

}
output "subnet2_id" {
  description = "subnet1 id cidr" 
  value = aws_subnet.subnet2.id

}
output "aws_security_group" {
  description = "security group services"
  value = aws_security_group.sg.id

}