  module "project_ec2" {
   source             = "./modules/ec2"
   instance_count     = 1
   name               = local.name
   account            = data.aws_caller_identity.current.account_id
   aws_ami            = "ami-0b9064170e32bde34"
   private_subnet_ids = module.vpc.private_subnet_ids
   public_subnet_ids  = var.public_subnet_ids
   vpc_id             = output.vpc_id.value
 }