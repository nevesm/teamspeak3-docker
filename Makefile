default: test

build:
	# Build image
	docker build -t "msmneves/teamspeak3:latest" .

hadolint:
	# Execute hadolint on Dockerfile
	docker run --rm -i \
		-v "$(CURDIR):$(CURDIR)" \
		-w "$(CURDIR)" \
		hadolint/hadolint \
		hadolint --ignore=DL3008 Dockerfile

official-tests: build
	# Execute official docker-image tests
	git clone https://github.com/docker-library/official-images.git /tmp/official-images
	/tmp/official-images/test/run.sh "msmneves/teamspeak3:latest"
	rm -rf /tmp/official-images

test: hadolint official-tests

update: teamspeak_version_update test tag

teamspeak_version_update:
	docker run --rm -i \
		-v "$(CURDIR):$(CURDIR)" \
		-w "$(CURDIR)" \
		python:3-alpine \
		sh -c "pip install -r patcher/requirements.txt && python3 patcher/index.py"

tag:
	bash ./patcher/tag.sh
