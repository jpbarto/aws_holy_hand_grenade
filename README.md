# Holy Handgrenade of Antioch
A project for wiping an AWS account using AWS-Nuke in a serverless fashion.

This project uses Terraform to define an ECS Fargate task into an AWS account.  When executed the task will run, deleting all resources in the account.  The task will then complete leaving no billing resources behind.