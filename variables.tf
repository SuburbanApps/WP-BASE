# Global variables

locals  {
 

  aws_region = "eu-west-1"
  vpc_id = "vpc-dc76d7bb"
  private_subnet_ids = ["subnet-650ae83e", "subnet-ea19bc8d",""] #"subnet-c9cd6f80"
  public_subnet_ids = ["subnet-c009eb9b", "subnet-971cb9f0",""]#"subnet-48d67401"
  key_pair = "dv10-wp-base"


}