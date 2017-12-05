# ================= ASG Config ==========================

# Launch config required for ASG 
resource "aws_launch_configuration" "web" {
  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.web.id}"]

  # Final rendered template
  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# Creation of ASG to manage cluster of web servers
resource "aws_autoscaling_group" "web" {
  
  # Configure the name parameter of the ASG to depend directly on the name of the launch configuration. That way, each time the launch configuration changes (which it will when you update the AMI or User Data), Terraform will try to replace the ASG.
  name = "${var.cluster_name}-${aws_launch_configuration.web.name}"
  launch_configuration = "${aws_launch_configuration.web.id}"
  
  vpc_zone_identifier = ["${var.public_subnet_id}"]

  availability_zones = ["ap-southeast-1a"]

  # ASG run between 2 and 10 EC2 instances, each tagged with the name of the cluster name
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  min_elb_capacity = "${var.min_size}"

  # Tell the ASG to register each Instance in the ELB when that instance is booting
  load_balancers = ["${aws_elb.load_balancer.name}"]
  
  # This tells the ASG to use the ELB’s health check to determine if an Instance is healthy or not and to automatically restart Instances if the ELB reports them as unhealthy.
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "${var.cluster_name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}