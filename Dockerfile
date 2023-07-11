FROM python:3.11-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG GH_USER
ARG GH_PAT

# Configure env
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VERSION=1.4.2 \
    POETRY_HOME="/usr/src/poetry" \
    POETRY_CACHE_DIR="/usr/src/poetry/cache" \
    POETRY_VIRTUALENVS_IN_PROJECT="true"

ENV PATH="$POETRY_HOME/bin:$PATH"

# Install OS dependencies
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    vim \
    openssh-server \
    curl; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config http-basic.fastapi-auth-utils "$GH_USER" "$GH_PAT"

WORKDIR /code

COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry install

# Set commands
COPY src/app .

ENTRYPOINT ["/usr/src/entrypoint"]

CMD ["uvicorn", "app.main:app", "--host 0.0.0.0", "--port 8000", "--reload"]