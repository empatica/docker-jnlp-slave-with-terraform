IMAGE = empatica/jnlp-slave-with-terraform
VERSION = 0.9.6-2

.PHONY: build push release

default: release

build:
	docker build -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)

release: build push
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest
