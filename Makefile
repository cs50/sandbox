run:
	docker run -it -P --rm --security-opt seccomp=unconfined cs50/sandbox bash -l || true

build:
	docker build -t cs50/sandbox .

rebuild:
	docker build --no-cache -t cs50/sandbox .
