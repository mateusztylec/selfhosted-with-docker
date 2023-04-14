FROM python:3.11.0

RUN mkdir -p /www/docs && touch mkdocs.yml

WORKDIR /www

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY docs docs
COPY mkdocs.yml mkdocs.yml

CMD ["mkdocs", "serve"]

EXPOSE 8000
# EXPOSE 8000/udp