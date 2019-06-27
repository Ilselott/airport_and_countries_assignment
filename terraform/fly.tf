# ------------------------------------------------------------------
# DEFINE OUR VARIABLES
# ------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8000
}

# ------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

# ------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# ------------------------------------------------------------------
data "aws_availability_zones" "all" {}

# ------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP
# ------------------------------------------------------------------
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 10

  load_balancers    = ["${aws_elb.example.name}"]
 # health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# ------------------------------------------------------------------
# CREATE THE KEY PAIR
# ------------------------------------------------------------------

resource "aws_key_pair" "key" {
key_name = "loeliathevenin"
public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# ------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
# ------------------------------------------------------------------

resource "aws_launch_configuration" "example" {
  image_id        = "ami-01f3682deed220c2a"
  instance_type   = "t3.medium"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name = "${aws_key_pair.key.key_name}"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo curl https://raw.githubusercontent.com/Ilselott/airport_and_countries_assignment/master/terraform/install.sh > /home/ec2-user/install.sh
              sudo chmod 755 /home/ec2-user/install.sh
              sudo ./home/ec2-user/install.sh
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# ------------------------------------------------------------------

resource "aws_security_group" "instance" {

  name = "terraform-example-instance"
  
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = "80"
    to_port     = "80"
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

# ------------------------------------------------------------------
# CREATE AN ELB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ------------------------------------------------------------------
resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   interval            = 30
  #   target              = "HTTP:${var.server_port}/airports/NL"
  # }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = 8000
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
}

# ------------------------------------------------------------------
# CREATE A SECURITY GROUP THAT CONTROLS WHAT TRAFFIC AN GO IN AND OUT OF THE ELB
# ------------------------------------------------------------------
resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
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

}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
