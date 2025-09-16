# Run tests
test:
	docker compose exec web pytest

# Format code
format:
	docker compose exec web black .

# Lint with flake8
lint:
	docker compose exec web flake8 .

# Type check
types:
	docker compose exec web mypy .