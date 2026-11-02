output "cluster_name" {
    value = aws_eks_cluster.myeks.id
}

output "cluster_endpoint" {
    value = aws_eks_cluster.myeks.endpoint
}

output "configure_kubectl" {
    value = "aws eks update-kubeconfig --name ${aws_eks_cluster.myeks.name} --region us-east-1"
}