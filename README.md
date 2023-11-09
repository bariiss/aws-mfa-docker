# AWS MFA Docker Environment

This project provides a containerized environment for managing AWS credentials with Multi-Factor Authentication (MFA). It utilizes a Docker container to encapsulate the `aws-mfa` tool and related dependencies, providing a consistent and isolated setup for credential management.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Docker is installed and running on your system.
- You have an AWS account and have generated an access key ID and secret access key.
- You have configured an MFA device in the AWS IAM console.

## Configuration

Create a `.env` file in the root of the project directory with the following content, updated with your AWS credentials and configuration:

```env
AWS_PROFILE=default
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
AWS_MFA_DEVICE=arn:aws:iam::account_id:mfa/device_name
AWS_MFA_SECRET_KEY=your_mfa_secret_key
AWS_MFA_STS_DURATION=129600
AWS_REGION=your_aws_region
AWS_OUTPUT=json
```

## Building and Running

### Building the Docker Image

To build the Docker image, run the following command:

```code
make docker-build
```

This will create a Docker image named `aws-mfa-docker` based on Alpine Linux, with all the necessary tools installed.

### Running AWS MFA

To run the AWS MFA process, execute:

```code
make aws-mfa
```

This command will start a Docker container from the aws-mfa-docker image, mount your local AWS configuration files, and execute the MFA process.

## Makefile Targets

- **create-aws-folder**: Ensures the **.aws** directory exists in your home folder.
- **create-aws-cred-conf**: Creates AWS credentials and config files if they do not exist.
- **aws-mfa**: Runs the entire MFA process, including Docker container execution and MFA code generation.

## Docker.mk

The **Docker.mk** file includes the necessary make targets to set up and manage the AWS profiles within the Docker environment.