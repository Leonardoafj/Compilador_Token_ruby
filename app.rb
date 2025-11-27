require 'sinatra'
require 'json'
require 'base64'
require 'openssl'
require 'time'
require 'dotenv/load'

set :port, ENV.fetch('PORT', 4567)
set :bind, '0.0.0.0'
set :protection, except: [:host_header, :http_origin]

puts "Variáveis de ambiente disponíveis:"
puts ENV.select { |k,_| k.include?('TOKEN') }.inspect

# ou simplesmente:
puts "TOKEN_SECRET está definido? #{ENV.key?('TOKEN_SECRET')}"



# Chave secreta – em produção, use ENV!
SECRET_KEY = ENV.fetch('TOKEN_SECRET')
class TokenCompiler
  def self.compile(payload)
    payload = payload.dup
    payload['exp'] = (Time.now + 600).to_i # 10 minutos
    header = Base64.urlsafe_encode64(payload.to_json, padding: false)
    signature = OpenSSL::HMAC.hexdigest('sha256', SECRET_KEY, header)
    "#{header}:#{signature}"
  end

  def self.verify(token)
    return nil unless token&.include?(':')
    header_str, signature = token.split(':', 2)
    return nil unless signature

    expected_sig = OpenSSL::HMAC.hexdigest('sha256', SECRET_KEY, header_str)
    return nil unless secure_compare(expected_sig, signature)

    begin
      payload = JSON.parse(Base64.urlsafe_decode64(header_str), symbolize_names: true)
    rescue JSON::ParserError, ArgumentError
      return nil
    end

    if payload[:exp] && Time.now.to_i > payload[:exp]
      return { error: 'Token expirado' }
    end

    payload
  rescue => e
    { error: 'Token inválido' }
  end

  private

  def self.secure_compare(a, b)
    return false unless a && b && a.bytesize == b.bytesize
    l = a.bytesize
    result = 0
    (0...l).each { |i| result |= a.getbyte(i) ^ b.getbyte(i) }
    result.zero?
  end
end

# === ROTAS ===

get '/' do
  erb :index
end

post '/gerar' do
  # Coleta dados do formulário
  dados = {
    'cpf' => params[:cpf]&.strip,
    'nome' => params[:nome]&.strip,
    'email' => params[:email]&.strip
  }

  # Validação mínima
  if dados['cpf'].nil? || dados['cpf'].empty? || dados['nome'].nil? || dados['nome'].empty?
    @erro = "CPF e Nome são obrigatórios."
    return erb :index
  end

  begin
    @token = TokenCompiler.compile(dados)
  rescue => e
    @erro = "Erro ao gerar token: #{e.message}"
  end

  erb :index
end

get '/validar' do
  erb :validar
end

post '/validar' do
  @token_input = params[:token]&.strip

  if @token_input.nil? || @token_input.empty?
    @erro = "Por favor, insira um token."
  else
    resultado = TokenCompiler.verify(@token_input)
    if resultado.is_a?(Hash) && resultado[:error]
      @erro = resultado[:error]
    elsif resultado.is_a?(Hash)
      @payload = resultado
    else
      @erro = "Token inválido ou corrompido."
    end
  end

  erb :validar
end
