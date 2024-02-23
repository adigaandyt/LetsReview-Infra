module "network" {
  source = "./modules/network"

  name_prefix        = var.name_prefix
  vpc_cidr_block     = var.vpc_cidr_block
  subnet_count       = var.subnet_count
  availability_zones = var.availability_zones
  subnet_cidr_offset = var.subnet_cidr_offset
}

module "eks" {
  source = "./modules/eks"

  name_prefix = var.name_prefix
  subnet_ids  = module.network.subnet_ids

    depends_on = [
    module.network
  ]
}

module "nodes" {
  source             = "./modules/nodes"

  name_prefix        = var.name_prefix
  eks_name           = module.eks.cluster_name
  subnet_ids         = module.network.subnet_ids
  instance_types     = var.instance_types
  ng_max_size        = var.ng_max_size
  ng_min_size        = var.ng_min_size
  ng_desired_size    = var.ng_desired_size
  ng_max_unavailable = var.ng_max_unavailable

  depends_on = [
    module.eks
  ]
}

module "argocd" {
  source                     = "./modules/argocd"

  argocd_values_filepath     = var.argocd_values_filepath
  gitops_ssh_secret_arn      = var.gitops_ssh_secret_arn
  bootstrap_application_path = var.bootstrap_application_path
  gitops_repo_url            = var.gitops_repo_url
  database_secret_arn        = var.database_secret_arn

  depends_on = [
    module.nodes
  ]
}






