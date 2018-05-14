## Purpose of this project is to deploy Airflow using terraform in a eu-west-1 region. 

## Prerequesites
- Terraform v0.11.7
- AWS CLI 1.11.170
- Python 2.7
- EC2 Keypairs 
- IAM User with appropriate permissions
- AWS Access Key and Secret Key
- Development and testing was done on a macOS High Sierra version 10.13.4
 
## main.tf
This file provides CDIR block design for Prod VPC and Corp.

## variables.tf
This file provides strategy to migrate local mysql to RDS.

## userdata.sh
This file installs
