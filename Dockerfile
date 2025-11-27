FROM ruby:3.2

WORKDIR /app

# Instale dependências de sistema, se necessário (exemplo para sqlite3 ou pg)
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Fly.io usa a porta 8080
EXPOSE 8080

# Sinatra precisa receber a porta do Fly
ENV PORT=8080

# Diga ao rackup para usar o arquivo 'app.rb'
CMD ["bundle", "exec", "rackup", "app.rb"]