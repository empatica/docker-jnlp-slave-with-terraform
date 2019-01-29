IMAGE = empatica/jnlp-slave-with-terraform
VERSION = 0.11.11

.PHONY: build push release shell

default: release

build:
	docker build -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)

release: build push
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest

shell: build
	docker run -it --rm $(IMAGE):$(VERSION) /bin/bash
