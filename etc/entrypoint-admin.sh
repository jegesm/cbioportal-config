#! /bin/bash


cd /cbioportal/cbioportal/
#git pull
#/usr/bin/python3 manage.py makemigrations hub
#/usr/bin/python3 manage.py migrate
/usr/bin/python3 manage.py runserver 0.0.0.0:80
