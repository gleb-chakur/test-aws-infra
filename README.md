# test-aws-infra

This setup creates the following resources:

VPC
One public and one private subnet per AZ
Routing tables for the subnets
Internet Gateway for public subnets
NAT gateways with attached Elastic IPs for the private subnet
Two security groups
one that allows HTTP/HTTPS access
one that allows access to the specified container port
An ALB + target group with listeners for port 80 and 443
An ECR for the docker images
An ECS cluster with a service (incl. auto scaling policies for CPU and memory usage) and task definition to run docker containers from the ECR (incl. IAM execution role)


I'm going to create 4 subnets. There will be 2 subnets for the load balancer and 2 subnets for the ECS tasks to be placed in.

I use 2 subnets for each because there will a subnet in each availability zone in the eu-east-1 region. The number of subnets might be different depending on the requirement, but in this case this configuration is made for safety reasons.

For security reasons, you would want two route tables. You would want a public route table that routes traffic to the internet gateway, and a second route table that routes traffic to a NAT Gateway.

We need an internet gateway to give internet access to the ALB(public subnet) and to the Fargate subnets(private), so they can download the docker image.

I created one security group for the ALB that allows only access via TCP ports 80 and 443 (aka HTTP and HTTPS). Another security group is needed for the ECS task that will later house our container, allowing ingress access only to the port that is exposed by the task.

I decided to go with a Fargate configuration. Fargate is the service that allows you to run containers “serverless”, meaning you don’t have to take care of the underlying hosts/EC2 instances.

I need a place where the docker image can be pulled from by the ECS service, where I used ECR. Notable here is that image_tag_mutability is set to be MUTABLE. This is necessary in order to put a latest tag on the most recent image.What I added is a so-called lifecycle policy, to make sure I don’t keep too many versions of image, as with every new deployment of the application, a new image would be created. 10 sounded like a reasonable number for this.
Also here the setup was pretty straight forward and the official Terraform documentation gives good examples. 

To make the setup super-sturdy, I also added some autoscaling rules to the service. The first thing I needed for this was an autoscaling target.I defined that the maximum number of task to be run should be 4, while at least one task should be running at all time.So with this configuration, according to requirments, if the average memory utilization rises over 75 percent or the average cpu utilization is more than 75, the service will automatically put more tasks to work (up to a maximum of four as defined in the scaling target).