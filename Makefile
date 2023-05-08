BROKER_BINARY=brokerApp
AUTH_BINARY=authApp

up:
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

k8s_up:
	@echo "Deploying k8s application"
	kubectl apply -f auth-service-deployment.yaml,broker-service-deployment.yaml,go-talkie-auth--env-configmap.yaml,kafka-service.yaml,mysql-db-claim-persistentvolumeclaim.yaml,mysql-db-service.yaml,zookeeper-deployment.yaml,auth-service-service.yaml,broker-service-service.yaml,kafka-deployment.yaml,my-db-persistentvolumeclaim.yaml,mysql-db-deployment.yaml,mysql-persistentVolume.yaml,zookeeper-service.yaml
	@echo "Done!"

k8s_down:
	@echo "Killing k8s application"
	kubectl delete -f auth-service-deployment.yaml,broker-service-deployment.yaml,go-talkie-auth--env-configmap.yaml,kafka-service.yaml,mysql-db-claim-persistentvolumeclaim.yaml,mysql-db-service.yaml,zookeeper-deployment.yaml,auth-service-service.yaml,broker-service-service.yaml,kafka-deployment.yaml,my-db-persistentvolumeclaim.yaml,mysql-db-deployment.yaml,mysql-persistentVolume.yaml,zookeeper-service.yaml
	@echo "Done!"