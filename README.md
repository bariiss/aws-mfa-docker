# AWS MFA Docker Environment

This project provides a containerized environment for managing AWS credentials with Multi-Factor Authentication (MFA). It utilizes a Docker container to encapsulate the `aws-mfa` tool and related dependencies, providing a consistent and isolated setup for credential management. With this setup, you can start the MFA process easily using Docker. It automatically handles the MFA token for you, so there's no need to type in codes manually. This makes the whole process much easier and hassle-free.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- `Docker` is installed and running on your system.
- You have an `AWS account` and have generated an access key ID and secret access key.
- You have configured an `MFA device` in the AWS IAM console.

Additionally, this project uses the [`aws-mfa`](https://github.com/broamski/aws-mfa) tool for the MFA process. The Docker container will include this tool, so there is no need for a separate installation.

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

### Using Pre-Built Docker Image

Instead of building the image yourself, you can simply pull the pre-built Docker image from Docker Hub:

```sh
docker pull bariiss/aws-mfa-docker:latest
docker run -it --rm \
	-v ~/.aws/credentials:/root/.aws/credentials \
	-v ~/.aws/config:/root/.aws/config \
	--env-file .env \
	bariiss/aws-mfa-docker:latest
```

### Building the Docker Image

If you wish to build the Docker image yourself, you can do so with:

```code
make docker-build
```

This will create a Docker image named `aws-mfa-docker` based on Alpine Linux, with all the necessary tools installed.

### Running AWS MFA

The beauty of using this Dockerized environment is the simplicity it brings to the MFA process. With the following command:

```code
make aws-mfa
```

This command will start a Docker container from the `aws-mfa-docker` image, mount your local AWS configuration files, and execute the MFA process.

## Makefile Targets

- **create-aws-folder**: Ensures the **.aws** directory exists in your home folder.
- **create-aws-cred-conf**: Creates AWS credentials and config files if they do not exist.
- **aws-mfa**: Runs the MFA process, including Docker container execution and MFA code generation, all automated for ease and security.

## Docker.mk

The `Docker.mk` file includes necessary make targets to set up and manage the AWS profiles within the Docker environment, automating profile creation and configuration synchronization.

By using this Docker-based solution, you ensure that your MFA management is as effortless as it is secure, taking advantage of isolated environments and automated tooling.

> This updated `README.md` highlights the simplicity and automated nature of the MFA process when using the Docker container, and also includes the link to the `aws-mfa` tool for those interested in the tool's source or additional details.