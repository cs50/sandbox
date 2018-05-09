run: build
	docker run -it cs50/sandbox || true

build:
	docker build -t cs50/sandbox .
