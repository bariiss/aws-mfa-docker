# Function to create or update the AWS profile
define create_aws_profile
    $(eval AWS_PROFILE_EXISTS := $(shell grep -c "\[${AWS_PROFILE}\]" ~/.aws/credentials))
    @if [ -z "${AWS_PROFILE_EXISTS}" ] || [ "${AWS_PROFILE_EXISTS}" -eq 0 ]; then \
        echo "[${AWS_PROFILE}]" >> ~/.aws/credentials; \
        echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials; \
        echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials; \
        echo "aws_mfa_device = ${AWS_MFA_DEVICE}" >> ~/.aws/credentials; \
        echo "aws_mfa_duration = ${AWS_MFA_STS_DURATION}" >> ~/.aws/credentials; \
        echo "aws_mfa_secret_key = ${AWS_MFA_SECRET_KEY}" >> ~/.aws/credentials; \
        echo "AWS profile ${AWS_PROFILE} created."; \
    else \
        echo "AWS profile ${AWS_PROFILE} already exists."; \
    fi

	$(eval AWS_LONG_TERM_PROFILE_EXISTS := $(shell grep -c "\[${AWS_PROFILE}-long-term\]" ~/.aws/credentials))
	@if [ -z "${AWS_LONG_TERM_PROFILE_EXISTS}" ] || [ "${AWS_LONG_TERM_PROFILE_EXISTS}" -eq 0 ]; then \
		echo "[${AWS_PROFILE}-long-term]" >> ~/.aws/credentials; \
		echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials; \
		echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials; \
		echo "aws_mfa_device = ${AWS_MFA_DEVICE}" >> ~/.aws/credentials; \
		echo "aws_mfa_duration = ${AWS_MFA_STS_DURATION}" >> ~/.aws/credentials; \
		echo "aws_mfa_secret_key = ${AWS_MFA_SECRET_KEY}" >> ~/.aws/credentials; \
		echo "AWS long term profile ${AWS_PROFILE}-long-term created."; \
	else \
		echo "AWS long term profile ${AWS_PROFILE}-long-term already exists."; \
	fi

	$(eval AWS_CONFIG_EXISTS := $(shell grep -c "\[${AWS_PROFILE}\]" ~/.aws/config))
	@if [ -z "${AWS_CONFIG_EXISTS}" ] || [ "${AWS_CONFIG_EXISTS}" -eq 0 ]; then \
		echo "[${AWS_PROFILE}]" >> ~/.aws/config; \
		echo "region = ${AWS_REGION}" >> ~/.aws/config; \
		echo "output = ${AWS_OUTPUT}" >> ~/.aws/config; \
		echo "AWS config ${AWS_PROFILE} created."; \
	else \
		echo "AWS config ${AWS_PROFILE} already exists."; \
	fi
endef

# Target to create the AWS profile
create-aws-profile:
	@$(call create_aws_profile)

# Target for getting the verification code
get-verification-code:
	$(eval AWS_MFA_SECRET_KEY=$(shell awk '/\[${AWS_PROFILE}-long-term\]/{flag=1;next}/\[/{flag=0}flag' ~/.aws/credentials | grep 'aws_mfa_secret_key' | cut -d '=' -f 2 | tr -d ' '))
	@oathtool --base32 --totp $${AWS_MFA_SECRET_KEY}

# Target for running aws-mfa
aws-mfa: create-aws-profile
	@$(eval MFA_CODE := $(shell make get-verification-code | grep -o '[0-9]\{6\}'))
	@/usr/bin/expect -c "\
	set timeout -1; \
	spawn aws-mfa --force --profile	$(AWS_PROFILE); \
	expect \"Enter AWS MFA code for device\"; \
	send \"$(MFA_CODE)\r\"; \
	expect eof"

.PHONY: create-aws-profile get-verification-code aws-mfa
