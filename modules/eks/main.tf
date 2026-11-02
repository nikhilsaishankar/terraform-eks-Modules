resource "aws_eks_cluster" "myeks" {
    name = "my-eks-cluster"
    role_arn = var.eks_role_arn

    vpc_config {
        subnet_ids = var.subnet_ids
        endpoint_private_access = true
        endpoint_public_access = true
    } 

    tags = {
        Name = "my-eks-cluster"
    }
}

resource "aws_iam_role" "eks_nodes" {
    name = "eks-nodes-role"

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
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy"{
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy"{
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_iam_role_policy_attachment" "eks_registry_policy"{
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_eks_node_group" "nodes" {
     cluster_name = aws_eks_cluster.myeks.name
     node_group_name = "my-eks-node-group-2"
     node_role_arn = aws_iam_role.eks_nodes.arn
     subnet_ids =   var.subnet_ids
     instance_types = ["c7i-flex.large"]
     capacity_type = "SPOT"
     scaling_config {
        desired_size = 2 
        max_size = 4
        min_size = 2

     }
     update_config {
        max_unavailable = 1 
     }
}

