FROM ruby:3.2

WORKDIR /app

# Instale dependências de sistema (essencial para o build funcionar)
RUN apt-get update -qq && apt-get install -y build-essential libssl-dev libpq-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Fly.io usará a porta 4567
EXPOSE 4567

# Sinatra precisa receber a porta do Fly
ENV PORT=4567

# Comando de Inicialização do Rack/Sinatra
CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]