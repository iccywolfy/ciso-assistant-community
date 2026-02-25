FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1

WORKDIR /code

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libyaml-cpp-dev \
  ca-certificates && \
  rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv==0.6.9
ENV PATH="/root/.local/bin/:$PATH"

COPY . .

RUN uv sync --frozen

EXPOSE 8000
ENTRYPOINT ["uv", "run", "bash", "entrypoint.sh"]
