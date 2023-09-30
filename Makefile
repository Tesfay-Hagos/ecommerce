STRIPE_SECRET=sk_test_51NJ9hUHcyMtlcloOfRb6GtaOaWEVWsjB1rX5Ov34R0yEOd60lomMpj5icKMKQ5MydoYG3PMlZVU4uKITpRQY01Qd00C1hEW0Cf
STRIPE_KEY=pk_test_51NJ9hUHcyMtlcloOSHa3h0G0SenoYgqvlxk3roa3wbqWkLBSEtQDqjmmRQM4bPPGy22YsESPRSKyA5WYkGFB5Yqk00IQjACL7N
GOSTRIPE_PORT=4000
API_PORT=4001

## build: builds all binaries
build: clean build_front build_back
	@printf "All binaries built!\n"

## clean: cleans all binaries and runs go clean
clean:
	@echo "Cleaning..."
	@- rm -f dist/*
	@go clean
	@echo "Cleaned!"

## build_front: builds the front end
build_front:
	@echo "Building front end..."
	@go build -o dist/gostripe ./cmd/web
	@echo "Front end built!"

## build_back: builds the back end
build_back:
	@echo "Building back end..."
	@go build -o dist/gostripe_api ./cmd/api
	@echo "Back end built!"

## start: starts front and back end
start: start_front start_back

## start_front: starts the front end
start_front: build_front
	@echo "Starting the front end..."
	@STRIPE_KEY=$(STRIPE_KEY) STRIPE_SECRET=$(STRIPE_SECRET) ./dist/gostripe -port=$(GOSTRIPE_PORT) &
	@echo "Front end running!"

## start_back: starts the back end
start_back: build_back
	@echo "Starting the back end..."
	@STRIPE_KEY=$(STRIPE_KEY) STRIPE_SECRET=$(STRIPE_SECRET) ./dist/gostripe_api -port=$(API_PORT) &
	@echo "Back end running!"

## stop: stops the front and back end
stop: stop_front stop_back
	@echo "All applications stopped"

## stop_front: stops the front end
stop_front:
	@echo "Stopping the front end..."
	@-pkill -SIGTERM -f "gostripe -port=$(GOSTRIPE_PORT)"
	@echo "Stopped front end"

## stop_back: stops the back end
stop_back:
	@echo "Stopping the back end..."
	@-pkill -SIGTERM -f "gostripe_api -port=$(API_PORT)"
	@echo "Stopped back end"

## Example migrate commands (modify as needed)
migrate-down:
	@migrate -database "mysql://root:1172@tcp(127.0.0.1:3306)/ecommerce2fdb?parseTime=true&tls=false" -path /migrations -verbose down

migrate-up:
	@migrate -database "mysql://root:1172@tcp(127.0.0.1:3306)/ecommerce2fdb?parseTime=true&tls=false" -path /migrations -verbose up

migrate-create:
	@migrate create -ext sql -dir internal/migrations -tz "UTC" $(args)
