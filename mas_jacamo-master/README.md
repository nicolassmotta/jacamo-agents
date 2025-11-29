# Sistema de Gerenciamento de Recarga de Veículos Elétricos (SMA - Trabalho 2)

Este projeto implementa um Sistema Multiagente (SMA) utilizando o framework **JaCaMo** (Jason + CArtAgO + Moise) para simular um mercado de energia e estacionamento autônomo. O sistema foca na negociação de preços, gestão de concorrência por vagas e regulação dinâmica de tarifas.

## 📋 Descrição do Projeto

O sistema simula um cenário de cidade inteligente onde veículos autônomos buscam estações de recarga, negociam preços baseados na oferta/demanda e reagem a mudanças regulatórias.

### Principais Funcionalidades (Requisitos Atendidos):
* **Agentes Inteligentes:**
    * `veiculo`: Monitora bateria, busca estações, negocia preços e decide onde recarregar.
    * `estacao`: Define preços dinâmicos baseados na lotação e responde a requisições.
    * `regulador`: Agente fiscal que altera a tarifa base (Alta/Baixa) ciclicamente para testar a resiliência do mercado.
* **Organização (Moise):** Implementação da especificação organizacional `mercado_energia` com papéis de `consumidor`, `fornecedor` e `fiscal`.
* **Ambiente (CArtAgO):**
    * `EstacaoArtifact`: Gerencia a exclusão mútua das vagas e cálculo de preços.
    * `LoggerArtifact`: Gera logs em CSV para análise de dados e gráficos.
* **Escalabilidade:** Configurado e testado para cenários de alta densidade (50+ agentes), com tratamento de concorrência e falhas de alocação.

## 🚀 Como Executar

### Pré-requisitos
* Java JDK 17 ou superior.
* Terminal (Bash, CMD ou PowerShell).

### Passos
1.  **Clone o repositório** ou extraia os arquivos.
2.  **Abra o terminal** na pasta raiz do projeto.
3.  **Execute o comando:**

    No Linux/Mac/Git Bash:
    ```bash
    ./gradlew run
    ```

    No Windows (CMD/PowerShell):
    ```cmd
    gradlew.bat run
    ```

> **Nota:** A interface gráfica de debug do JaCaMo foi otimizada (abas desativadas) para garantir performance com 50 agentes. Acompanhe a execução pelo terminal ou pelos logs gerados.

## 📊 Configuração de Cenários

Para alterar os cenários de teste (quantidade de agentes), edite o arquivo `mas_jacamo.jcm`:

```javascript
agent veiculo : veiculo.asl {
    instances: 50  // Altere este número para 5, 50, 100 ou 150
    // ...
}
````

## 📈 Análise de Resultados

A cada execução, o sistema gera um arquivo na raiz do projeto com o nome:
`simulacao_log_[TIMESTAMP].csv`

Este arquivo contém:

  * Tempo da ação.
  * Agente envolvido.
  * Evento (Sucesso, Falha, Negociação).
  * Detalhes (Valores, Motivos).

Estes dados podem ser importados no Excel ou Python para gerar gráficos de desempenho e análise de concorrência.

## 🛠️ Estrutura do Projeto

  * `src/agt/`: Código fonte dos agentes (Jason/ASL).
  * `src/env/`: Código fonte dos artefatos (Java).
  * `src/org/`: Especificação da organização (XML).
  * `mas_jacamo.jcm`: Configuração principal e deploy.

-----

*Projeto desenvolvido para a disciplina de Sistemas Multiagentes - 2025.2 - UTFPR*