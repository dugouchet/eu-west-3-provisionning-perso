this repo contains : 

1 ALB ( running on 2 subnet in two different AZ)
2 public subnet in 2 AZ
1 VCP
1 intetnet gateway
1 ECR to push and store docker images
1 ASG with launch template to run EC2 with user data
I try to use user data to pull the docker image. I know this is not a best practice to run docker image on ec2. For production purpose I would rather user ECS for fargate to take advantage of serverless