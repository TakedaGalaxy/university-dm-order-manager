# Sistema de Gerenciamento de Pedidos para Restaurante

Este projeto é um sistema de gerenciamento de pedidos projetado para facilitar o fluxo de trabalho em um restaurante, envolvendo três perfis de usuário: **Chefe (Cozinheiro)**, **Garçom**, e **Administrador**. O sistema permite que a equipe do restaurante gerencie os pedidos de clientes de forma eficiente, desde a anotação do pedido até sua entrega final.

## Funcionalidades

### 1. Garçom
- **Criação de Pedidos:** O garçom pode anotar o pedido do cliente, especificar os itens e o número da mesa, e enviar o pedido para a cozinha.
- **Atualização de Pedidos:** Os garçons recebem notificações quando um pedido está pronto e podem mudar o status do pedido de "concluído" para "entregue."
- **Cancelar Pedidos:** Garçons também podem cancelar pedidos que ainda não foram concluídos.

### 2. Chefe (Cozinheiro)
- **Notificação de Pedido:** O chefe é notificado quando um novo pedido é criado.
- **Processamento de Pedidos:** O chefe pode visualizar a lista de pedidos, alterar o status do pedido para "sendo preparado" e, quando pronto, marcar como "concluído."

### 3. Administrador
- **Gerenciamento de Usuários:** O administrador tem acesso a uma tela de gerenciamento de funcionários, onde pode cadastrar, editar ou deletar garçons e cozinheiros.
- **Controle de Pedidos:** O administrador pode visualizar, atualizar ou cancelar qualquer pedido no sistema.
- **Registro:** O administrador é o único usuário que pode se cadastrar diretamente pela tela de registro, onde define o nome do restaurante e suas credenciais.

## Fluxo do Sistema

1. **Garçom cria o pedido:** O garçom anota o pedido do cliente, especifica a mesa e o envia.
2. **Chefe é notificado:** O chefe recebe o pedido e altera o status para "sendo preparado."
3. **Chefe conclui o pedido:** Quando a comida estiver pronta, o chefe atualiza o status do pedido para "concluído."
4. **Garçom entrega o pedido:** O garçom é notificado de que o pedido está pronto, entrega-o à mesa e marca o pedido como "entregue."
5. **Cancelamento de pedidos:** Pedidos podem ser cancelados antes de serem concluídos, tanto pelo garçom quanto pelo administrador.

## Estrutura do Projeto

O sistema está dividido em duas partes principais: **frontend** e **backend**. O frontend lida com a interface do usuário, enquanto o backend gerencia os dados, autenticação e lógica de processamento dos pedidos.

- [Documentação do Frontend](./frontend/README.md)
- [Documentação do Backend](./back-end/README.md)

## Instalação e Configuração

1. Clone o repositório:

    ```bash
    git clone https://github.com/TakedaGalaxy/university-dm-order-manager
    ```

2. Acesse as pastas `frontend` e `backend` e siga as instruções nos respectivos arquivos README para instalar as dependências e iniciar os serviços.

3. Personalize o sistema conforme as necessidades específicas do seu restaurante.