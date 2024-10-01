echo escriptorium is launching...
cd escriptorium
source env/bin/activate
cd app
sudo service postgresql start
sudo service redis-server start
DJANGO_SETTINGS_MODULE=escriptorium.local_settings celery -A escriptorium worker -l INFO & python manage.py runserver --settings escriptorium.local_settings