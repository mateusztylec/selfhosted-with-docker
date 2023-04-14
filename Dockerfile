FROM python:3.11.0

RUN mkdir /www

WORKDIR /www

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY docs .
COPY mkdocs.yml .

CMD ["mkdocs", "serve"]

EXPOSE 8000
# EXPOSE 8000/udp