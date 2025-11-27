FROM ruby:3.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Fly.io usa a porta 8080
EXPOSE 8080

# Sinatra precisa receber a porta do Fly
ENV PORT=8080

# Diga ao rackup para usar o arquivo 'app.rb'
CMD ["bundle", "exec", "rackup", "app.rb"]