# Instalação do Flutter e Execução do Frontend

## Pré-requisitos

- **Sistema Operacional**: Windows, macOS ou Linux
- **Espaço em Disco**: Pelo menos 2.8 GB (não incluindo espaço para IDE/tools)
- **Ferramentas**: Git para controle de versão

## Passo a Passo

### 1. Instalar o Flutter

#### Windows

1. Baixe o SDK do Flutter no site oficial: [Flutter SDK](https://flutter.dev/docs/get-started/install/windows)

2. Extraia o arquivo baixado para o local desejado (ex: `C:\src\flutter`)

3. Adicione o caminho do Flutter ao PATH:
   
   - Abra o Painel de Controle -> Sistema e Segurança -> Sistema -> Configurações avançadas do sistema
   - Clique em "Variáveis de Ambiente" e edite a variável `Path`
   - Adicione o caminho `C:\src\flutter\bin`

4. Verifique a instalação:
   
   ```shell
   flutter doctor
   ```

#### macOS

1. Baixe o SDK do Flutter no site oficial: [Flutter SDK](https://flutter.dev/docs/get-started/install/macos)

2. Extraia o arquivo baixado para o local desejado (ex: `~/development/flutter`)

3. Adicione o caminho do Flutter ao PATH:
   
   - Abra o terminal e edite o arquivo `~/.zshrc` ou `~/.bashrc`:
     
     ```shell
     export PATH="$PATH:`pwd`/flutter/bin"
     ```
   
   - Atualize o terminal:
     
     ```shell
     source ~/.zshrc
     ```

4. Verifique a instalação:
   
   ```shell
   flutter doctor
   ```

#### Linux

1. Baixe o SDK do Flutter no site oficial: [Flutter SDK](https://flutter.dev/docs/get-started/install/linux)

2. Extraia o arquivo baixado para o local desejado (ex: `~/development/flutter`)

3. Adicione o caminho do Flutter ao PATH:
   
   - Abra o terminal e edite o arquivo `~/.bashrc` ou `~/.zshrc`:
     
     ```shell
     export PATH="$PATH:`pwd`/flutter/bin"
     ```
   
   - Atualize o terminal:
     
     ```shell
     source ~/.bashrc
     ```

4. Verifique a instalação:
   
   ```shell
   flutter doctor
   ```

### 2. Configurar um Editor

Recomenda-se usar o Visual Studio Code ou Android Studio. Siga as instruções no site oficial do Flutter para configurar o editor: [Configurar Editor](https://flutter.dev/docs/get-started/editor)

### 3. Clonar o Repositório do Projeto

```shell
git clone git@github.com:TakedaGalaxy/university-dm-order-manager.git
cd university-dm-order-manager
```

### 4. Acessar a pasta `frontend`

```shell
cd frontend
```

### 4. Instalar Dependências

```shell
flutter pub get
```

### 5. Executar o Projeto

Conecte um dispositivo físico ou inicie um emulador, então execute:

```shell
flutter run
```

## Problemas Comuns

- **Dispositivo não detectado**: Verifique se o dispositivo está conectado e com a depuração USB ativada.
- **Erros de dependência**: Execute `flutter pub get` novamente para garantir que todas as dependências estão instaladas.

Para mais informações, consulte a documentação oficial do Flutter: [Flutter Documentation](https://flutter.dev/docs)