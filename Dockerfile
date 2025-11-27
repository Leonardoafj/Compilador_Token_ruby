# Dockerfile

# Stage 1: Ambiente de Build - Instala todas as dependências
FROM ruby:3.2.3-slim AS base

# Definir a pasta de trabalho
WORKDIR /app

# Instalar as ferramentas de compilação e as libs nativas necessárias (SSL é crucial)
RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev

# Copiar os arquivos de dependência e instalar as Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Stage 2: Ambiente Final de Execução - Mais leve e seguro
FROM ruby:3.2.3-slim

WORKDIR /app

# Copiar apenas as gems instaladas e a aplicação do Stage 1
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY . .

# Ambiente e Porta
ENV PORT=8080
EXPOSE 8080

# Comando de Inicialização: Agora ele deve funcionar perfeitamente com o config.ru e app.rb corrigidos.
# Voltamos para o comando que garante a escuta, confiando que o app.rb resolveu a segurança.
CMD ["bundle", "exec", "rackup", "-p", "8080", "-o", "0.0.0.0"]