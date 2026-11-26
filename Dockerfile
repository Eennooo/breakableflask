FROM python:3.13-alpine AS builder
RUN apk add --no-cache build-base libxml2-dev libxslt-dev
COPY requirements.txt .
RUN python -m venv /opt/venv \
 && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
 && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt \
 && /opt/venv/bin/pip uninstall -y pip

FROM python:3.13-alpine
RUN apk upgrade --no-cache \
 && pip uninstall -y pip \
 && addgroup -S app && adduser -S -G app -H app
COPY --from=builder /opt/venv /opt/venv
WORKDIR /app
COPY main.py .
ENV PATH="/opt/venv/bin:$PATH" PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
USER app
EXPOSE 4000
CMD ["python", "main.py"]
