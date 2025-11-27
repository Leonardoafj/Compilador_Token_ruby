FROM ruby:3.2

WORKDIR /app

# Adicione esta linha para resolver a falha de Build/Compilação de Gems
RUN apt-get update -qq && apt-get install -y build-essential libssl-dev libpq-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Fly.io usa a porta 8080
EXPOSE 8080

# Sinatra precisa receber a porta do Fly
ENV PORT=8080

# Removendo o 'app.rb' daqui para usar o padrão config.ru (ou deixar o Sinatra se bindar)
CMD ["bundle", "exec", "rackup", "-p", "8080", "-o", "0.0.0.0"]