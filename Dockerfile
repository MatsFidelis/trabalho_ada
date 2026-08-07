FROM scratch

LABEL org.opencontainers.image.title="trabalho-ada"
LABEL org.opencontainers.image.description="Projeto acadêmico de compliance contínuo"

WORKDIR /app
COPY package.json /app/package.json
COPY README.md /app/README.md
