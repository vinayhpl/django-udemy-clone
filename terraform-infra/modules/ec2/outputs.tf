output "micro_ip" {
  value = aws_instance.micro.public_ip
}

output "medium_ip" {
  value = aws_instance.ram-4gb.public_ip
}