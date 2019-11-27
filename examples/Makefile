.PHONY: docker check-env
.DEFAULT_GOAL := julia

ORG :=

check-env:
ifndef ORG
	$(error ORG is undefined)
endif

.SILENT: docker
docker:
	docker info 1> /dev/null 2> /dev/null && \
	if [ ! $$? -eq 0 ]; then \
		echo "\n[ERROR] Could not communicate with docker daemon. You may need to run with sudo.\n"; \
		exit 1; \
	fi

julia: julia.Dockerfile run_julia.py | docker check-env	
	docker build -t $(ORG)/$@:latest -f $< .
	docker push $(ORG)/$@:latest
