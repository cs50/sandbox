run: build
	docker run -it -P --rm cs50/sandbox bash -l || true

build:
	docker build -t cs50/sandbox .

rebuild:
	docker build --no-cache -t cs50/sandbox .
