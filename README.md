# 📈 Magnata da Bolsa: Simulador Financeiro

> Um jogo de simulação econômica e mercado financeiro interativo desenvolvido para a plataforma Roblox.

🎮 **[Clique aqui para jogar Magnata da Bolsa no Roblox](https://www.roblox.com/games/71755812504853/Magnata-da-Bolsa-Simulador-Financeiro)**

---

## 📌 Sobre o Projeto

O **Magnata da Bolsa** é um simulador econômico completo construído em **Luau (Roblox Studio)**. O projeto foi projetado para introduzir e simular conceitos reais do mercado financeiro, incluindo dividendos de Fundos Imobiliários (FIIs), volatilidade de ações especulativas, compra de bens de luxo com rentabilidade passiva, escalonamento de multiplicadores e um sistema progressivo de Rebirth.

---

## 🚀 Funcionalidades Principais

- **📊 Mercado de Ações & FIIs (Fundos Imobiliários):**
  - **FIIs:** Pagamento dinâmico de dividendos líquidos a cada **1 segundo**, com cálculo em tempo real de *Yield*.
  - **Ações (Stocks):** Algoritmo de oscilação especulativa contínua a cada segundo.
  - **Gestão de Carteira:** Ordens de compra e venda em lotes (`1x`, `10x`, `100x` e `Tudo`) com cálculo automático de **Preço Médio (PM)** e resultado financeiro em tempo real.

- **🏰 Renda Passiva de Bens de Luxo (+110 Itens):**
  - Progressão de ativos de luxo (de patinetes a estações espaciais e estruturas multiversais) gerando injeção passiva de capital a cada **5 segundos** (20% da base do item).

- **💼 Corretoras & Multiplicadores (+78 Opções):**
  - Sistema de contratação de corretoras que concedem bônus percentuais cumulativos sobre todos os rendimentos de FIIs e Bens.

- **🚀 Mecânica de Rebirth (Progressão Contínua):**
  - Reinício de saldo e portfólio de bens em troca de um **bônus global permanente de +25%** por nível de Rebirth.
  - **Persistência Estratégica:** As corretoras contratadas permanecem ativas após o Rebirth para acelerar a recuperação da carteira.

- **💾 Persistência de Dados Robusta (`DataStoreService`):**
  - Salvamento automático (*autosave*) com intervalo configurável de 120 segundos.
  - Tratamento de exceções assíncronas com `pcall`, limite de retentativas e suporte a `BindToClose` para garantir o salvamento de todos os jogadores antes da desativação do servidor.

- **⚙️ Ferramentas do Desenvolvedor (Dev Tools):**
  - Validação estrita de permissões via `UserId` com modal de confirmação no jogo para testes e resets no ambiente de desenvolvimento.

---

## 📐 Decisão de Arquitetura: Por que a lógica foi centralizada em um `ServerScript`?

A estruturação da lógica de negócios, cálculo financeiro e interface em um único script de servidor foi uma decisão técnica deliberada fundamentada nos seguintes princípios:

1. **Segurança *Server-Authoritative*:**
   Em um jogo com modelo econômico, todas as transações, rendimentos e alterações de saldo são processados estritamente no servidor. Isso elimina vulnerabilidades no cliente (*exploits*) e previne a alteração não autorizada de memória.

2. **Fonte Única da Verdade (*Single Source of Truth*):**
   Manter a tabela de dados em memória dos jogadores (`playerDataMap`), os loops de oscilação do mercado e a interface reativa no mesmo contexto de execução garante consistência absoluta de dados e previne condições de corrida (*race conditions*).

3. **Renderização e Atualização Reativa de UI:**
   A interface gráfica é atualizada diretamente pelo loop de estado do jogador (loops de 1s e 5s), eliminando a necessidade de tráfego constante de requisições por `RemoteEvents` na rede.

4. **Persistência de Dados Integrada (`DataStoreService`):**
   A integração direta entre o estado em memória dos jogadores e o salvamento em banco de dados simplifica o desligamento do servidor (`BindToClose`) e garante que dados críticos sejam salvos atomicamente sem concorrência de scripts.

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Luau (Lua 5.1+ estendida para Roblox)
- **Plataforma:** Roblox Studio
- **Serviços Globais do Roblox:** `DataStoreService`, `Players`, `RunService`

---

## 📁 Estrutura do Repositório

```text
magnata-da-bolsa-simulador-financeiro/
├── README.md                              # Documentação do projeto
├── Magnata_da_Bolsa_Simulador.rbxl        # Arquivo completo do lugar (Roblox Studio)
├── src/
│   └── server/
│       └── ServerScript.lua               # Código-fonte principal da economia
└── assets/
    └── preview.png                        # Capturas de tela da interface do jogo
