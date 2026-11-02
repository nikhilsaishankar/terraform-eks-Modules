output "subnet_ids" {
    value = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
}