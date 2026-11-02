module "networking" {
    source = "./modules/networking"
}

module "eks" {
    source = "./modules/eks"
    subnet_ids   = module.networking.subnet_ids
    eks_role_arn = module.iam.eks_role_arn
    depends_on   = [module.iam]

}

module "iam" {
    source = "./modules/iam"
}