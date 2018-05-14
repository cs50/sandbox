run: build
	docker run -it cs50/sandbox || true

build:
	docker build --no-cache -t cs50/sandbox .
