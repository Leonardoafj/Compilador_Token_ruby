# Dockerfile

FROM ruby:3.2.3

WORKDIR /app

# Instalação das bibliotecas nativas antes do bundle install
# build-essential: Para compilação
# libssl-dev: CRUCIAL para OpenSSL/Criptografia (Usado no seu código)
# libpq-dev: Para PostgreSQL (Boa prática, mesmo que não use)
RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Ambiente e Porta
ENV PORT=8080
EXPOSE 8080

# Comando de Inicialização (Voltando ao padrão mais simples que confia no config.ru)
CMD ["/usr/local/bin/rackup", "-o", "0.0.0.0", "-p", "8080"]