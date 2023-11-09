aws-mfa: create-aws-cred-conf
	@if ! docker image inspect aws-mfa-docker:latest > /dev/null 2>&1; then \
		make docker-build; \
	fi
	@docker run -it --rm \
	-v ~/.aws/credentials:/root/.aws/credentials \
	-v ~/.aws/config:/root/.aws/config \
	--env-file .env \
	aws-mfa-docker:latest

create-aws-folder:
	@mkdir -p ~/.aws

create-aws-cred-conf: create-aws-folder
	@if [ ! -f ~/.aws/credentials ]; then touch ~/.aws/credentials; fi
	@if [ ! -f ~/.aws/config ]; then touch ~/.aws/config; fi

docker-build: remove-build
	@docker build -t aws-mfa-docker --no-cache .
	@echo "INFO: aws-mfa-docker image built successfully."; \

remove-build:
    @if docker image inspect aws-mfa-docker:latest > /dev/null 2>&1; then \
        docker rmi -f aws-mfa-docker; \
        echo "INFO: aws-mfa-docker image removed successfully."; \
    else \
        echo "INFO: aws-mfa-docker image does not exist."; \
    fi

.PHONY: create-aws-folder create-aws-cred-conf docker-build remove-build aws-mfa