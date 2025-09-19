# sue-shop
Docker-compose to run a PostgreSQL database (db) → stores all your e-commerce app data (products, users, orders, etc.)
Run your Django web app (web) → serves the e-commerce site, talks to the database, and uses Stripe for payments.
Docker-compose connect them together automatically → the app can reach the database without extra setup.
docker-compose keep the database data safe with a volume (pgdata) so it doesn’t get wiped when containersare stopped.
docker-compose expose ports so:
Visit the app at http://localhost:8000.
Also connect to the database on localhost:5432 if needed.

PRE-DEPLOYMENT CHECKLIST
<!-- # 1. Backup the production database
make db-backup

# 2. Pull latest changes from Git
git pull origin main

# 3. Rebuild production images (fresh)
make rebuild

# 4. Restart production stack with new images
make prod -->

PRODUCTION-WORKFLOW
<!-- # 1. Start production stack (Gunicorn + Nginx + db)
make prod

# 2. Run database migrations
make migrate

# 3. Collect static files for Django
make collectstatic

# 4. Create superuser (only once per new production DB)
make createsuperuser

# 5. Verify logs to ensure all services are healthy
make logs

# 6. Backup the database (before risky changes or deploys)
make db-backup

# 7. Work with production system (deploy, monitor, test)

# 8. If needed, restore database from backup
make db-restore

# 9. Shut down production stack cleanly
make down -->

DEVELOPMENT-WORKFLOW ROUTINE
<!-- make dev
make migrate
make createsuperuser   # only if needed
make logs              # watch services
# work on code...
make test              # before committing
make lint
make format
make down              # end of day -->

DEPLOYMENT-DAILY-WORKFLOW
<!-- # 5. Run migrations (apply schema changes safely)
make migrate

# 6. Collect static files for Django
make collectstatic

# 7. Restart services to apply changes
make prod -->

POST-DEPLOYMENT WORKFLOW
<!-- # 8. Check logs for errors or warnings
make logs

# 9. Run smoke tests (basic sanity checks in the app UI)

# 10. If something goes wrong:
make db-restore   # rollback database
git reset --hard <last_good_commit>
make prod         # restart with last good version -->