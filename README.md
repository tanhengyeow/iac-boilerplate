# IAC-Boilerplate

## Pre-requisities
1. [Register for an AWS Account](https://aws.amazon.com/)
   1. Head over to the IAM Console and create an user with the following permissions:
      1. AmazonRDSFullAccess
      2. AmazonEC2FullAccess
      3. AmazonS3FullAccess
      4. AmazonDynamoDBFullAccess
      5. AmazonVPCFullAccess
   2. Export your AWS user credentials as environment variables
      1. `$ export AWS_ACCESS_KEY_ID="<YOUR ACCESS KEY>"`
      2. `$ export AWS_SECRET_ACCESS_KEY="<YOUR SECRET ACCESS KEY>"`
      3. If you didn't export the environment variables correctly, you will see an error message like this later, `Error configuring the backend "s3": No valid credential sources found for AWS Provider.`
2. [Terraform v0.10.0](https://www.terraform.io/downloads.html)
   1. Tip: Always use `terraform plan` before `terraform apply`
 
## Layout of infrastructure

This project provisions the infrastructure shown below in AWS with the help of terraform.

![Layout of infrastructure](https://github.com/tanhengyeow/iac-boilerplate/blob/master/img/infrastructure-v1.jpg)

### VPC (Data Center)

The public subnet consists of a cluster of web servers designed to host web applications. A elastic load balancer (ELB) is used to distribute traffic across the servers. The ELB acts as an entry point for the public to access the web applications.

The private subnet consists of an Amazon RDS DB Instance designed to be a data store for the web applications. Communication is allowed between the database and the web servers but the public cannot access the private subnet. A NAT Gateway is set up for the RDS DB Instance to access the internet for software updates.

### VPC (Office)

The private subnet consists of provisioned client machines in a simulated office environment. The set up allows the client machines to access the internet through a NAT Gateway.

## Setup/Walkthrough

1. Clone this project
2. Set up your S3 bucket. This bucket would be used as a remote state storage for your `terraform.tfstate` files. With remote state enabled, Terraform will automatically pull the latest state from this S3 bucket before running a command and automatically push the latest state to the S3 bucket after running a command. This setup is mandatory if you are working in a team.

```
./live/global/s3

$ terraform plan
$ terraform apply
```

3. Set up Amazon DynamoDB. This setup is used to lock your `terraform.tfstate` files to prevent race conditions.

```
./live/global/dynamodb

$ terraform plan
$ terraform apply
```

4. Set up the virtual private cloud of `VPC (Data Center)`. Edit the input variables of `./live/stage/vpc/data-center/main.tf` if you want to set up the environment differently. Note the output generated. You will need some of these values later.

```
./live/stage/vpc/data-center

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

5. Set up the RDS DB Instance in the private subnet of `VPC (Data Center)`. From the output generated in step 4, edit the input variables of `./live/stage/services/data-storage/mysql/main.tf` accordingly. If you didn't manage to obtain the output generated previously, go back to the `./live/stage/vpc/data-center` and run `terraform output`.

```
./live/stage/services/data-storage/mysql

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

6. Set up the cluster of web servers and the ELB in the public subnet of `VPC (Data Center)`. Similarly, edit the the input variables of `./live/stage/services/webserver-cluster/main.tf` accordingly. The output `elb_dns_name` is the entry point that allows the public to access the web application.

```
./live/stage/services/webserver-cluster

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

7. Set up the virtual private cloud of `VPC (Office)`. Edit the input variables of `./live/stage/vpc/office/main.tf` if you want to set up the environment differently. Note the output generated.

```
./live/stage/vpc/office

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

8. Set up the security group of `VPC (Office)`. From the output generated in step 7, edit the input variables of `./live/stage/office-environment/security-group/main.tf` accordingly. Note the output generated.

```
./live/stage/office-environment/security-group

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

9. Set up the client machines in `VPC (Office)`. From the output generated in step 7 and 8, edit the input variables of `./live/stage/office-environment/client/main.tf` accordingly for both module `linux_client` and `windows_client`.

```
./live/stage/office-environment/client

$ terraform get
$ terraform init
$ terraform plan
$ terraform apply
```

To destroy the entire infrastructure, go to each folder that you have ran `terraform apply` previously and execute
```
$ terraform destroy
```

# Suggestions for what's ahead

* Provisioning the software in server/client machine using configuration management tools e.g. Ansible
* Using server templating tools e.g. packer to create images 
* Creating custom ami to launch in AWS
* Other pull requests are welcome!
