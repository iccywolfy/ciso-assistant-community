#!/usr/bin/env bash
# wait for database to be ready
if [ ! -n "$DJANGO_SETTINGS_MODULE" ]; then
  export DJANGO_SETTINGS_MODULE=ciso_assistant.settings
fi
if [ ! -n "$DJANGO_SECRET_KEY" ]; then
  echo "WARNING: DJANGO_SECRET_KEY not set via environment. Falling back to file-based key (not recommended for production)."
  if [ ! -f db/django_secret_key ]; then
    python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())" >db/django_secret_key
    echo "INFO: Generated new Django secret key and saved to db/django_secret_key."
  fi
  export DJANGO_SECRET_KEY=$(<db/django_secret_key)
  echo "INFO: Django secret key loaded from file."
else
  echo "INFO: Using DJANGO_SECRET_KEY from environment variable."
fi
while ! python manage.py showmigrations iam >/dev/null; do
  echo "database not ready; waiting"
  sleep 15
done
poetry run python manage.py migrate --settings="${DJANGO_SETTINGS_MODULE}"
poetry run python manage.py storelibraries --settings="${DJANGO_SETTINGS_MODULE}"
if [ -n "$DJANGO_SUPERUSER_EMAIL" ]; then
  poetry run python manage.py createsuperuser --noinput --settings="${DJANGO_SETTINGS_MODULE}"
fi

# Set default values for Gunicorn configuration
GUNICORN_WORKERS=${GUNICORN_WORKERS:-3}
GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-100}
GUNICORN_KEEPALIVE=${GUNICORN_KEEPALIVE:-30}
GUNICORN_LIMIT_REQUEST_LINE=${GUNICORN_LIMIT_REQUEST_LINE:-5120}
GUNICORN_PORT=${PORT:-8000}

exec gunicorn --chdir ciso_assistant \
  --bind :$GUNICORN_PORT \
  --timeout $GUNICORN_TIMEOUT \
  --keep-alive $GUNICORN_KEEPALIVE \
  --workers=$GUNICORN_WORKERS \
  --limit-request-line=$GUNICORN_LIMIT_REQUEST_LINE \
  --env RUN_MAIN=true \
  ciso_assistant.wsgi:application
