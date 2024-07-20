# Pull base image
FROM python:3.12.2-slim-bookworm

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set work directory called `app`
RUN mkdir -p /code
WORKDIR /code

# Install dependencies
COPY requirements.txt /tmp/requirements.txt

RUN set -ex && \
pip install --upgrade pip && \
pip install -r /tmp/requirements.txt && \
rm -rf /root/.cache/

# Copy local project
COPY . /code/

# Set the port number as an environment variable
ARG PORT
ENV PORT $PORT

# Expose the given port
EXPOSE $PORT

# Use gunicorn on the given port
CMD gunicorn --bind :$PORT --workers 2 django_project.wsgi
