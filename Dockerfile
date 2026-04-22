# Pull base image
FROM python:3.12.2-slim-bookworm

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create a non-root user
RUN groupadd -r django && useradd -r -g django django

# Create and set work directory called `code`
RUN mkdir -p /code && chown django:django /code
WORKDIR /code

# Install dependencies
COPY requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

# Copy local project
COPY --chown=django:django . /code/

# Set the port number as an environment variable (default to 8000 for zero-config)
ARG PORT=8000
ENV PORT $PORT

# Expose the given port
EXPOSE $PORT

# Switch to non-root user
USER django

# Use gunicorn on the given port
CMD gunicorn --bind :$PORT --workers 2 django_project.wsgi
