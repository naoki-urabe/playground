go-build:
	docker build -f dockerfiles/Dockerfile.go -t go:plg .
go-run:
	docker run -it -v $(PWD):/go/src --detach go:plg