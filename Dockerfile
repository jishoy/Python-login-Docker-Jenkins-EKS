FROM  python:3.8-slim-buster

WORKDIR /authenticate
RUN pip3 install django-cms

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY . .
EXPOSE 8002
CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8002" ]
