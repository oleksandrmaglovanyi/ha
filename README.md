## Mabaya DevOps Fullstack - Home assignment
It is sample project for python echo-server application deployment to docker on EC2 instance, or for deployment to locally installed docker runtime.

For EC2 instance application is built and deployed via user-data script started by cloud-init on the instance. 

Local deployment assumes that user has already istalled Docker runtime on his computer before running terraform.

Project confirmed to be working in WSL 2.0 with Docker Desktop.

**!!!!ATTN!!!!**: **Terraform** project uses default security group and **removes all security rules** from there.
Should be run on clean and unused environment only.

## Echo-server service details

It is a fork from one dosens of similar projects from GitHub.
Service is listening 3246 tcp port, which is mapped to 80 external port in the docker instance.

It was exteded a bit to produce request log in `requests.raw` file placed in the same directory where echo.py is located, so it is not using any persistent volume for that purpose.
To read that log you have to use `cp` docker command:

``` docker cp echo-server:/app/requests.raw requests.raw ```



## How to deploy and test:

- Install git, curl, terraform and local docker runtime
- ensure that current user has own ssh key in .ssh/id_rsa.pub file. Or just generate it:
 ```test ! -f ~/.ssh/id_rsa.pub && ssh-keygen -t rsa```
- clone this repo
`git clone https://github.com/oleksandrmaglovanyi/ha.git`
- run terraform to install service in local docker:
``` cd ha/terraform && terraform init && terraform apply ```
- run terraform to install service as docker on EC2 instance:
``` cd ha/terraform && terraform init && terraform apply -var local=false ```
 - test echo service:
``` curl `terraform output -raw service_ip`/url-to-echo-back```

## Possible HA scenarios:
1. Create ALB with autoscaling or just simple ALB between two or more EC2 instances.
2. Move project from EC2 to EKS (overkill) or ECS(preferred) and setup there same ALB.

## Example monitoring:

Since that AWS is used - the most obvoius (and simplest in current exact situation) way is to use CloudWatch percentile metrics for ALB that should be setup in HA scenario mentioned earlier.
Without ALB echo-server service should be refactored, so it will produce more detailed log with request duration at least, so it could be fed to CW agent and used for percentile metrics in the CW. But it is not the simplest way, I suppose.
