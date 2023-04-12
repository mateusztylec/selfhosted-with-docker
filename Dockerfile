FROM python:3.11.0-alpine3.17

# Build-time flags
ARG WITH_PLUGINS=true

# Environment variables
ENV PACKAGES=/usr/local/lib/python3.11/site-packages
ENV PYTHONDONTWRITEBYTECODE=1

# Set build directory
WORKDIR /tmp

# Copy files necessary for build
COPY docs docs
# COPY package.json package.json
COPY README.md README.md
COPY requirements.txt requirements.txt
# COPY pyproject.toml pyproject.toml

# Perform build and cleanup artifacts and caches
RUN \
  apk upgrade --update-cache -a \
&& \
  apk add --no-cache \
    cairo \
    freetype-dev \
    git \
    git-fast-import \
    jpeg-dev \
    openssh \
    zlib-dev \
&& \
  apk add --no-cache --virtual .build \
    gcc \
    libffi-dev \
    musl-dev \
&& \
  pip install --no-cache-dir . \
&& \
  if [ "${WITH_PLUGINS}" = "true" ]; then \
    pip install --no-cache-dir \
      "mkdocs-minify-plugin>=0.3" \
      "mkdocs-redirects>=1.0" \
      "pillow>=9.0" \
      "cairosvg>=2.5"; \
  fi \
&& \
  apk del .build \
&& \
  for theme in mkdocs readthedocs; do \
    rm -rf ${PACKAGES}/mkdocs/themes/$theme; \
    ln -s \
      ${PACKAGES}/material \
      ${PACKAGES}/mkdocs/themes/$theme; \
  done \
&& \
  rm -rf /tmp/* /root/.cache \
&& \
  find ${PACKAGES} \
    -type f \
    -path "*/__pycache__/*" \
    -exec rm -f {} \;

# Trust directory, required for git >= 2.35.2
RUN git config --global --add safe.directory /docs &&\
    git config --global --add safe.directory /site

# Set working directory
WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]