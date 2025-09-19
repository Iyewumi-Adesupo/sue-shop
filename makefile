# Project name (used for container prefix)
PROJECT = sue-shop

# Paths
FRONTEND_DIR ?= frontend/my-app
BACKEND_DIR  ?= backend

# Default compose files
COMPOSE = docker-compose
COMPOSE_DEV = -f docker-compose.yml -f docker-compose.override.yml
COMPOSE_PROD = -f docker-compose.yml -f docker-compose.prod.yml

# Database container name (from docker-compose.yml)
DB_CONTAINER = sue-shop-db
DB_USER = sall_suz
DB_NAME = sueshop

.PHONY: help dev prod backend-dev backend-shell frontend-dev frontend-build frontend-shell down logs ps rebuild clean db-shell db-backup db-restore migrate createsuperuser collectstatic shell test lint format

# Check if Docker is running
check-docker:
	@docker info > /dev/null 2>&1 || (echo "❌ Docker is not running! Please start Docker Desktop first." && exit 1)

# -----------------------------
# Targets
# -----------------------------

help:
	@echo "Available commands:"
	@echo "  make dev             - Run full development stack (backend + frontend + db)"
	@echo "  make prod            - Run full production stack (Gunicorn + Nginx + db)"
	@echo "  make backend-dev     - Run only Django backend + Postgres (no frontend)"
	@echo "  make backend-shell   - Open a bash shell inside backend container"
	@echo "  make frontend-dev    - Run only Vite React frontend in dev mode (port 5173)"
	@echo "  make frontend-build  - Build React frontend for production (npm run build)"
	@echo "  make frontend-shell  - Open an interactive shell inside frontend container"
	@echo "  make down            - Stop and remove containers, networks, volumes"
	@echo "  make logs            - Show logs from all services"
	@echo "  make ps              - Show running containers"
	@echo "  make rebuild         - Rebuild containers without cache"
	@echo "  make clean           - Remove ALL containers, volumes, and images (CAREFUL!)"
	@echo "  make db-shell        - Open a psql shell inside Postgres container"
	@echo "  make db-backup       - Backup the database to backups/db.sql"
	@echo "  make db-restore      - Restore database from backups/db.sql"
	@echo "  make migrate         - Run Django migrations inside backend container"
	@echo "  make createsuperuser - Create a Django admin user inside backend container"
	@echo "  make collectstatic   - Collect Django static files inside backend container"
	@echo "  make shell           - Open Django interactive Python shell inside backend"
	@echo "  make test            - Run Django unit tests inside backend container"
	@echo "  make lint            - Run flake8 and black checks inside backend container"
	@echo "  make format          - Auto-format code with black inside backend container"

dev:
	$(COMPOSE) $(COMPOSE_DEV) up --build

prod:
	$(COMPOSE) $(COMPOSE_PROD) up --build -d

backend-dev:
	$(COMPOSE) $(COMPOSE_DEV) up --build backend db

backend-shell:
	$(COMPOSE) exec backend sh

seed-products:
	$(COMPOSE) exec backend python manage.py loaddata shop/fixtures/products.json

reseed-products:
	$(COMPOSE) $(COMPOSE_DEV) exec backend python manage.py flush --no-input
	$(COMPOSE) $(COMPOSE_DEV) exec backend python manage.py loaddata shop/fixtures/products.json

frontend-dev:
	docker build -t $(PROJECT)-frontend-dev -f $(FRONTEND_DIR)/Dockerfile $(FRONTEND_DIR)
	docker run -it -p 5173:5173 -v $(PWD)/$(FRONTEND_DIR):/app $(PROJECT)-frontend-dev npm run dev -- --host 0.0.0.0

frontend-build:
	docker build -t $(PROJECT)-frontend -f $(FRONTEND_DIR)/Dockerfile $(FRONTEND_DIR)
	@echo "✅ Frontend production build complete (served by Nginx in prod mode)."

frontend-shell:
	$(COMPOSE) exec frontend sh

down:
	$(COMPOSE) down -v

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

rebuild:
	$(COMPOSE) build --no-cache

clean:
	docker system prune -af --volumes

db-shell:
	docker exec -it $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME)

db-backup:
	mkdir -p backups
	docker exec $(DB_CONTAINER) pg_dump -U $(DB_USER) $(DB_NAME) > backups/db.sql
	@echo "✅ Database backup saved to backups/db.sql"

db-restore:
	if [ -f backups/db.sql ]; then \
		cat backups/db.sql | docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME); \
		echo "✅ Database restored from backups/db.sql"; \
	else \
		echo "❌ No backup file found at backups/db.sql"; \
	fi

migrate:
	$(COMPOSE) exec backend python manage.py migrate

createsuperuser:
	$(COMPOSE) exec backend python manage.py createsuperuser

collectstatic:
	$(COMPOSE) exec backend python manage.py collectstatic --noinput

shell:
	$(COMPOSE) exec backend python manage.py shell

test:
	$(COMPOSE) exec backend python manage.py test

lint:
	$(COMPOSE) exec backend sh -c "flake8 . && black --check ."

format:
	$(COMPOSE) exec backend black .

backend-clean-start:
	@echo "🛑 Killing processes on ports 8000 and 5432 (if any)..."
	-@kill -9 $$(lsof -t -i:8000) 2>/dev/null || true
	-@kill -9 $$(lsof -t -i:5432) 2>/dev/null || true
	@echo "🚀 Starting backend + db..."
	$(COMPOSE) $(COMPOSE_DEV) up --build backend db

frontend-clean-start:
	@echo "🛑 Killing processes on port 5173 (if any)..."
	-@kill -9 $$(lsof -t -i:5173) 2>/dev/null || true
	@echo "🚀 Starting frontend..."
	docker build -t $(PROJECT)-frontend-dev -f $(FRONTEND_DIR)/Dockerfile $(FRONTEND_DIR)
	docker run -it -p 5173:5173 -v $(PWD)/$(FRONTEND_DIR):/app $(PROJECT)-frontend-dev npm run dev -- --host 0.0.0.0

# Save a new access token (login)
login:
	@read -p "Username: " USER; \
	read -s -p "Password: " PASS; echo ""; \
	RESPONSE=$$(curl -s -X POST http://localhost:8000/api/token/ \
	  -H "Content-Type: application/json" \
	  -d "{\"username\":\"$$USER\",\"password\":\"$$PASS\"}"); \
	echo $$RESPONSE | jq -r '.access' > .token; \
	echo $$RESPONSE | jq -r '.refresh' > .refresh; \
	echo "✅ Access token saved to .token"; \
	echo "✅ Refresh token saved to .refresh"

refresh-token:
	@REFRESH=$$(cat .refresh); \
	NEW_ACCESS=$$(curl -s -X POST http://localhost:8000/api/token/refresh/ \
	  -H "Content-Type: application/json" \
	  -d "{\"refresh\":\"$$REFRESH\"}" | jq -r '.access'); \
	echo $$NEW_ACCESS > .token; \
	echo "🔄 Access token refreshed and saved to .token"

# Get orders with stored token
get-orders:
	@TOKEN=$$(cat .token); \
	curl -s -H "Authorization: Bearer $$TOKEN" http://localhost:8000/api/orders/ | jq
