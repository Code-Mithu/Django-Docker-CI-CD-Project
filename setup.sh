#!/bin/bash

echo "Bootstrapping new Django-Docker project..."

# 1. Generate a secure random Django secret key
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(50))")

# 2. Create the .env file dynamically
cat <<EOF > .env
# Security Settings
SECRET_KEY=$SECRET_KEY
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Settings
DB_NAME=my_production_db
DB_USER=django_user
DB_PASSWORD=$(python3 -c "import secrets; print(secrets.token_urlsafe(20))")
EOF

echo " Secure .env file generated!"
echo " Starting Docker containers..."

# 3. Start Docker
docker compose up -d --build

# 4. Wait a few seconds for the DB to boot, then run migrations
echo "Waiting for Database to initialize..."
sleep 5
docker compose exec web python manage.py migrate

echo "Setup Complete! Your production-ready app is running on http://localhost:8000"
