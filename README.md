# 🔐 Token Compiler — Assinatura Digital Simulada (Portfólio)

![Ruby](https://img.shields.io/badge/Ruby-3.2%2B-red?logo=ruby)
![Sinatra](https://img.shields.io/badge/Sinatra-4.x-blue?logo=sinatra)
![License](https://img.shields.io/badge/License-MIT-green)

Um projeto educacional em **Ruby + Sinatra** que simula um sistema de **assinatura digital leve**, inspirado em tokens usados por serviços governamentais.

Gera tokens assinados com HMAC-SHA256, com expiração automática, e permite validação independente — ideal para autenticação stateless em APIs simples.

> ⚠️ **Não é um substituto para certificados ICP-Brasil**, mas perfeito para aprendizado, portfólio ou protótipos.

## 🌟 Funcionalidades

- 📝 Formulário para inserir dados (CPF, nome, e-mail)
- 🔐 Geração de token assinado com chave secreta
- ⏳ Expiração automática (10 minutos)
- 🔍 Validação independente via segunda rota
- 🌗 Tema claro/escuro automático
- 📱 Design responsivo

## 🚀 Como rodar localmente

1. **Clone o repositório**
  ```bash
  git clone 
  cd token-compiler
   
2. **Instale as dependências**
  bundle install

3. **Configure a chave secreta**
  cp .env.example .env
    # Edite .env e defina TOKEN_SECRET com uma chave forte
    # Dica: use `ruby -r securerandom -e "puts SecureRandom.hex(32)"`

4. **Inicie o servidor**
  ruby app.rb

5. **Acesse: http://localhost:4567**



🔒 Segurança
Chaves secretas nunca são versionadas (usamos .env + .gitignore)
Tokens usam HMAC-SHA256 para integridade
Expiração automática evita reutilização
📦 Tecnologias
Ruby 3.2+
Sinatra (framework web leve)
dotenv (gestão de variáveis locais)
HTML5 + CSS3 (sem frameworks externos)


----------------------------------------------------------

## 🧼 3. Organização final (opcional, mas recomendado)

Adicione ao `.gitignore`:

```gitignore
.env
*.log
/tmp