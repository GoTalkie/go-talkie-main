BROKER_BINARY=brokerApp
AUTH_BINARY=authApp

up: build_broker build_auth
	@echo "Stopping docker images (if running...)"
	docker-compose down
	@echo "Building (when required) and starting docker images..."
	docker-compose up --build -d
	@echo "Docker images built and started!"

down:
	@echo "Stopping docker images (if running...)"
	docker-compose down

build_broker:
	@echo "Building broker binary..."
	cd ./go-talkie-broker && env GOOS=linux CGO_ENABLED=0 go build -o .build/${BROKER_BINARY} ./cmd/broker
	@echo "Done!"

build_auth:
	@echo "Building auth binary..."
	cd ./go-talkie-auth && env GOOS=linux CGO_ENABLED=0 go build -o .build/${AUTH_BINARY} ./cmd/auth-app
	@echo "Done!"