# Sistema de Gerenciamento de Pedidos - Backend

Este é o backend do **Sistema de Gerenciamento de Pedidos para Restaurante**, desenvolvido com **Node.js**, **TypeScript**, e **Prisma**, utilizando o banco de dados **SQLite**. O sistema gerencia os pedidos de um restaurante, permitindo que diferentes perfis de usuários (Garçom, Chefe, Administrador) possam interagir de forma eficiente com o fluxo de pedidos.

## Tecnologias Utilizadas

- **Node.js**: Plataforma de execução de JavaScript no servidor.
- **TypeScript**: Linguagem que adiciona tipagem estática ao JavaScript, melhorando a legibilidade e a segurança do código.
- **Prisma**: ORM utilizado para interagir com o banco de dados de maneira simples e eficiente.
- **SQLite**: Banco de dados relacional leve, ideal para ambientes de desenvolvimento.

## Funcionalidades do Backend

- **Autenticação de Usuários**: Perfis de usuários como Garçom, Chefe e Administrador.
- **Gerenciamento de Pedidos**: Criação, atualização, visualização e cancelamento de pedidos.
- **Controle de Status de Pedidos**: Os pedidos podem ter seus status alterados para "sendo feito", "concluído" e "entregue".
- **Gerenciamento de Funcionários**: O Administrador pode cadastrar, editar ou remover funcionários.

## Estrutura de Pastas

```bash
backend/
├── prisma/           # Configurações do Prisma e banco de dados
│   ├── migrations/   # Migrações do Prisma
│   └── schema.prisma # Esquema do banco de dados
├── src/              # Código fonte do projeto em TypeScript
│   ├── middleware/   # Middlewares utilizados para facilitar desenvolvimento
│   ├── Router/       # Definições de rotas da API
│   ├── services/     # Logica de negocios
│   ├── utils/        # Utilizdades para facilitar desenvolvimento
│   └── main.ts       # Arquivo principal para inicialização do servidor
├── .env              # Arquivo de variáveis de ambiente (configuração do banco de dados)
├── nodemon.json      # Configuração do nodemon para hot reload
├── setup.ts          # Script para popular dados necessarios para aplicação
├── package.json      # Dependências e scripts do projeto
├── tsconfig.json     # Configurações do TypeScript
└── README.md         # Instruções e documentação do projeto
```

## Instruções para Execução

### 1. Clonar o Repositório

Primeiro, clone o repositório em sua máquina local:

```bash
git clone https://github.com/TakedaGalaxy/university-dm-order-manager
cd back-end
```

### 2. Instalar Dependências

Após clonar o repositório, instale as dependências do projeto com o **npm**:

```bash
npm install
```

### 3. Inicializar o Prisma e Gerar o Banco de Dados

Agora, inicialize o Prisma e aplique as migrações para configurar o banco de dados:

```bash
npx prisma migrate dev --name init
```

Depois, gere o cliente Prisma:

```bash
npx prisma generate
```

### 4. Popular com dados necessario

```bash
npm run setup
```

### 5. Executar o Servidor

Com todas as dependências instaladas e o banco de dados configurado, inicie o servidor:

```bash
npm run dev
```

O servidor estará rodando localmente em `http://127.0.0.1:4000`.
