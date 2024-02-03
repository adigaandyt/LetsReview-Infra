module "network" {
  source             = "./modules/network"
  name_prefix        = "andy"
  subnet_count       = 3
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

module "eks" {
  source      = "./modules/eks"
  name_prefix = "andy"
  subnet_ids  = module.network.subnet_ids
}

module "nodes" {
  source         = "./modules/nodes"
  name_prefix    = "andy"
  eks_name       = module.eks.cluster_name
  subnet_ids     = module.network.subnet_ids
  instance_types = ["t3a.medium"]
    depends_on = [
    module.eks
  ]
}

module "argocd" {
  source          = "./modules/argocd"
  values_filepath = "./argocd-files/argocd-values.yaml"

  depends_on = [
    module.eks
  ]
}






