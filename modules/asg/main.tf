
resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "cluster"
}

module launchconfig {
  source = "../lg"
}

module vpc {
  source = "../vpc"
}

# autoscaling group
resource "aws_autoscaling_group" "aws_asg" {
  name                 = "chris-tf-asg"
  vpc_zone_identifier  = ["${module.vpc.subnet_1_id}", "${module.vpc.subnet_2_id}"]
  launch_configuration = "${module.launchconfig.launch_config_id}"
  
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  placement_group           = aws_placement_group.test.id
  health_check_grace_period = 100
  health_check_type         ="EC2"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }   
}