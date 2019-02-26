# AWS_MISP
Build out a simple MISP instance in AWS

I <3 [MISP](https://github.com/MISP/MISP).

Here's a simple Terraform script to build out an AWS environment for MISP.

 * ec2 - EC2 instance for MISP
 * rds - MySQL backend for MISP


This is a work in progress, but should be enough to get you started.

I would use [git-crypt](https://github.com/AGWA/git-crypt) to encrypt my variables.tf but haven't for the sake of clarity here. Don't commit passwords to Github


The *secure/cloud-conf/misp-cloud-conf.tpl* file is a very simple cloud-init file which I need to work on.

Most of the build work should happen in a Packer image which I also need to work on.
