# Sistema de Gerenciamento de Recarga de Veículos Elétricos (SMA - Trabalho 2)

Este projeto é uma extensão do Trabalho 1 da disciplina de Sistemas Multiagentes, implementado agora utilizando o framework **JaCaMo** (Jason + CArtAgO + Moise). O sistema simula um mercado de energia competitivo para veículos autônomos em uma cidade inteligente.

## 📋 Funcionalidades Implementadas

O sistema modela um cenário onde veículos elétricos autônomos buscam recarga, negociam preços dinamicamente e lidam com a escassez de vagas e regulação de tarifas.

### 1. Agentes Inteligentes (Jason)

* **`veiculo`**: Agente comprador. Monitora sua bateria, busca estações, inicia leilões (Contract Net Protocol), negocia contra-propostas e decide onde recarregar com base no preço e disponibilidade. Implementa lógica de **retry** para conexão robusta.

* **`estacao`**: Agente vendedor. Existem 4 instâncias com perfis diferentes (`norte`, `sul`, `leste`, `oeste`). Calculam preços baseados na lotação (Oferta/Demanda) e aceitam/rejeitam propostas.

* **`regulador`**: Agente fiscal. Altera ciclicamente a tarifa base do mercado (Alta/Baixa) para simular choques externos e testar a adaptação dos agentes.

### 2. Ambiente Compartilhado (CArtAgO)

* **`EstacaoArtifact`**: Gerencia o estado físico de cada estação (vagas totais vs ocupadas) e garante exclusão mútua (thread-safe) para evitar que dois carros peguem a mesma vaga.

* **`CSVLogger`**: Artefato customizado para persistência de dados. Grava eventos de negociação, vendas e falhas em arquivos `.csv` para análise posterior, suportando alta concorrência.

### 3. Organização (Moise)

* **Grupo `mercado_energia`**: Define os papéis (`consumidor`, `fornecedor`, `fiscal`) e as normas de interação dentro do workspace `mercado`.

## 🚀 Como Executar

### Pré-requisitos

* Java JDK 17 ou superior.

* Terminal (Bash ou PowerShell).

### Passos

1. **Permissões (Linux/Mac):**
   Garanta que o script de execução tenha permissão:

   ```bash
   chmod +x gradlew
````

2.  **Executar a Simulação:**

    ```bash
    ./gradlew run
    ```

    (No Windows, use `gradlew.bat run`)

3.  **Acompanhar:**
    A simulação abrirá logs no terminal mostrando as negociações. O sistema roda até ser interrompido (Ctrl+C).

## 📊 Configuração de Cenários (Escalabilidade)

Para atender ao requisito de testes com **50, 100 e 150 agentes**, edite o arquivo `mas_jacamo.jcm`:

```javascript
mas mas_jacamo {
    agent veiculo : veiculo.asl {
        instances: 50  // <--- ALTERE AQUI PARA 50, 100 ou 150
        join: mercado
    }
    // ...
}
```

### Variação de Estações

As estações possuem configurações diferentes hardcoded no agente `estacao.asl` para criar heterogeneidade:

  * **Norte:** 20 vagas (Preço Base: 1.0)

  * **Sul:** 10 vagas (Preço Base: 0.8)

  * **Leste:** 15 vagas (Preço Base: 1.2 - Área Nobre)

  * **Oeste:** 8 vagas (Preço Base: 0.9)

## 📈 Análise de Resultados (Logs)

A cada execução, um arquivo de log é gerado automaticamente na pasta `log/` com o nome:
`simulacao_YYYYMMDD_HHMMSS.csv`

**Estrutura do CSV:**

```csv
Timestamp;Agente;Evento;Detalhes
14:35:01.123;veiculo5;Bateria_Baixa;Nivel: 60
14:35:01.450;veiculo5;Negociacao;Contra-oferta para estacao_norte
14:35:02.000;estacao_norte;Venda;Reserva confirmada para veiculo5
```

Estes dados devem ser utilizados para gerar os gráficos de **Taxa de Sucesso**, **Preço Médio** e **Ocupação** solicitados no relatório final.

## 🛠️ Estrutura de Pastas

  * `src/agt/`: Código fonte dos agentes (`.asl`).

  * `src/env/`: Código Java dos artefatos (`EstacaoArtifact.java`, `CSVLogger.java`).

  * `src/org/`: Especificação organizacional (`org.xml`).

  * `mas_jacamo.jcm`: Arquivo de configuração e deploy.

-----

*Projeto desenvolvido para a disciplina de Sistemas Multiagentes - 2025.2 - UTFPR*