FROM public.ecr.aws/docker/library/python:3.10-alpine
ENV FLASK_RUN_HOST=0.0.0.0

WORKDIR /
RUN adduser -u 1000 -D app

# Install build dependencies and native uwsgi/pcre packages via apk to avoid compilation errors
RUN apk update && \
  apk add --no-cache \
  pcre \
  pcre-dev \
  build-base \
  gcc \
  linux-headers \
  openssl \
  libffi-dev \
  uwsgi \
  uwsgi-python3 \
  && pip install --no-cache-dir --upgrade pip pipenv

RUN mkdir -p /var/www/app && mkdir /app

# Copy Pipfiles and install remaining python packages
COPY Pipfile* /app/
RUN cd /app && pipenv install --system --deploy --skip-lock || pipenv install --system --skip-lock

COPY . /app

WORKDIR /app
CMD ["uwsgi", "--http", ":5000", "--master", "--enable-threads", "-s", "/var/www/app/app.sock", "--manage-script-name", "--mount", "/=movies.app:app"]