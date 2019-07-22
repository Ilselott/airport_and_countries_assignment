# ------------------------------------------------------------------
# DEFINE OUR VARIABLES
# ------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

# ------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "fly" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "fly VPC"
  }
}

resource "aws_internet_gateway" "fly_igw" {
  vpc_id = "${aws_vpc.fly.id}"
}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.fly.id}"
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.fly_igw.id}"
  }
}

resource "aws_route_table_association" "rta_subnet_a" {
  subnet_id      = "${aws_subnet.sub_a.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route_table_association" "rta_subnet_b" {
  subnet_id      = "${aws_subnet.sub_b.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route_table_association" "rta_subnet_c" {
  subnet_id      = "${aws_subnet.sub_c.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

# ------------------------------------------------------------------
# CREATE THE KEY PAIR
# ------------------------------------------------------------------

resource "aws_key_pair" "key" {
key_name = "loeliathevenin"
public_key = "${file("~/.ssh/id_rsa.pub")}"
}


# ------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# ------------------------------------------------------------------
data "aws_availability_zones" "all" {}

resource "aws_subnet" "sub_a" {
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.fly.id}"
}

resource "aws_subnet" "sub_b" {
  availability_zone = "eu-west-1b"
  cidr_block = "10.0.16.0/24"
  vpc_id = "${aws_vpc.fly.id}"
}

resource "aws_subnet" "sub_c" {
  availability_zone = "eu-west-1c"
  cidr_block = "10.0.32.0/24"
  vpc_id = "${aws_vpc.fly.id}"
}

# ------------------------------------------------------------------
# CREATE THE AIRPORTS AUTO SCALING GROUP
# ------------------------------------------------------------------
resource "aws_autoscaling_group" "airports" {
  launch_configuration = "${aws_launch_configuration.airports.id}"
  vpc_zone_identifier  = ["${aws_subnet.sub_a.id}", "${aws_subnet.sub_b.id}", "${aws_subnet.sub_c.id}", ]

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "airports-asg"
    propagate_at_launch = true
  }
}

# ------------------------------------------------------------------
# CREATE THE COUNTRIES AUTO SCALING GROUP
# ------------------------------------------------------------------
resource "aws_autoscaling_group" "countries" {
  launch_configuration = "${aws_launch_configuration.countries.id}"
  vpc_zone_identifier  = ["${aws_subnet.sub_a.id}", "${aws_subnet.sub_b.id}", "${aws_subnet.sub_c.id}", ]

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "counties-asg"
    propagate_at_launch = true
  }
}

# ------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE COUNTRIES ASG
# ------------------------------------------------------------------

resource "aws_launch_configuration" "countries" {
  image_id        = "ami-01f3682deed220c2a"
  instance_type   = "t3.medium"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name = "${aws_key_pair.key.key_name}"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/fly-v2/install-countries.sh > /home/ec2-user/install.sh
              sudo chmod 755 /home/ec2-user/install.sh
              sudo ./home/ec2-user/install.sh
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE AIRPORTS ASG
# ------------------------------------------------------------------

resource "aws_launch_configuration" "airports" {
  image_id        = "ami-01f3682deed220c2a"
  instance_type   = "t3.medium"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name = "${aws_key_pair.key.key_name}"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/fly-v2/install-airport.sh > /home/ec2-user/install.sh
              sudo chmod 755 /home/ec2-user/install.sh
              sudo ./home/ec2-user/install.sh
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------
# CREATE THE ALB
# ------------------------------------------------------------------

resource "aws_alb" "alb" {
  name               = "fly-alb"
  security_groups    = ["${aws_security_group.instance.id}"]
  subnets            = ["${aws_subnet.sub_a.id}", "${aws_subnet.sub_b.id}", "${aws_subnet.sub_c.id}"]
}

resource "aws_alb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_alb.alb.arn}"  
  port              = "80"  
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type    = "text/plain"
      message_body    = "page not found"
      status_code     = "404"
    }
  }
  
}

resource "aws_alb_listener_rule" "countries" {
  action {
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.target_countries.id}"  
  }   
  listener_arn       = "${aws_alb_listener.alb_listener.arn}"  
  condition {    
    field            = "path-pattern"
    values           = ["/countries/*"]
  }
}

resource "aws_alb_target_group" "target_countries" {  
  name               = "target-countries"  
  port               = "${var.server_port}"  
  protocol           = "HTTP"
  vpc_id             = "${aws_vpc.fly.id}"
}

resource "aws_autoscaling_attachment" "attatchment_countries" {
  alb_target_group_arn   = "${aws_alb_target_group.target_countries.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.countries.id}"
}

resource "aws_alb_listener_rule" "airports" {
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.target_airports.id}"  
  }
    listener_arn = "${aws_alb_listener.alb_listener.arn}"  
  condition {
    field  = "path-pattern"
    values = ["/airports/*"]  
  }
}

resource "aws_alb_target_group" "target_airports" {  
  name     = "target-airports"  
  port     = "${var.server_port}"  
  protocol = "HTTP"  
  vpc_id   = "${aws_vpc.fly.id}"
}

resource "aws_autoscaling_attachment" "attachement_airports" {
  alb_target_group_arn   = "${aws_alb_target_group.target_airports.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.airports.id}"
}

# ------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# ------------------------------------------------------------------

resource "aws_security_group" "instance" {

  name = "terraform-example-instance"
  vpc_id =  "${aws_vpc.fly.id}"
  
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
