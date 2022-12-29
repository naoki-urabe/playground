build-db:
	docker build -f docker/Dockerfile.postgres -t postgres:15.1 .
run-db:
	docker run -it \
		-e POSTGRES_PASSWORD=password \
		-p 5432:5432 postgres:15.1 \
		-d postgres
