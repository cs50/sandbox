run: build
	docker run -it codevolve

build:
	docker build -t codevolve .
