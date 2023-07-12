FROM python:3.11-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


# Configure env
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VERSION=1.4.2 \
    POETRY_HOME="/usr/src/poetry" \
    POETRY_CACHE_DIR="/usr/src/poetry/cache" 

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
RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /usr/src/app

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

COPY . .

CMD ["uvicorn", "src.app.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000"]