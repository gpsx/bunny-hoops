# 📜 Epic 03: History Screen - Records & Insights

## 1. Visão Geral
Este épico foca na implementação da tela de histórico, permitindo que o usuário visualize seu progresso a longo prazo. O objetivo é transformar os dados brutos salvos localmente em uma lista organizada cronologicamente por datas.

---

## 2. Funcionalidades e Regras de Negócio
- **Cálculo de Total Geral:** Somatório de todas as entradas registradas desde o primeiro uso.
- **Agrupamento por Data:** O sistema deve varrer o banco de dados local e agrupar múltiplos registros ocorridos no mesmo dia em uma única entrada na lista.
- **Formatação Cronológica:** A lista deve ser exibida de forma decrescente (da data mais recente para a mais antiga).
- **Tratamento de Strings:** Exibir apenas o dia e o mês (ex: "18 de Out"), sem o uso de termos relativos como "Hoje" ou "Ontem".

---

## 3. Task 3.1: Data Architecture & Aggregation (Lógica)
**Objetivo:** Preparar a camada de dados para fornecer informações já mastigadas para a View.

- **Implementação do Repositório:** Criar um método que recupere todos os registros e os organize em um `Map` onde a chave é a data (sem horas) e o valor é a quantidade de ocorrências.
- **Lógica da ViewModel:** - Consumir o repositório de forma assíncrona.
    - Transformar os dados em um estado que a tela possa iterar facilmente.
    - Garantir que o estado seja atualizado automaticamente caso o usuário registre um novo pensamento na outra tela.

---

## 4. Task 3.2: UI Development (Bunny Core Design)
**Objetivo:** Construir os componentes visuais baseados nas imagens de referência e no Spec Kit.

- **Header Card (Métricas):**
    - Criar um container com bordas arredondadas (`rCard: 28.0`).
    - Centralizar o contador total com a cor `Primary` e o ícone de coelho ao lado.
    - Aplicar fonte `Plus Jakarta Sans` em estilo "Headline".
- **Lista de Registros:**
    - Utilizar um componente de lista (ListView) com espaçamento padronizado (`p16`).
    - Cada item da lista deve ser um card minimalista (estilo "tile").
    - Lado esquerdo: Nome do mês e dia em texto neutro.
    - Lado direito: O número de registros em destaque (cor `Primary`).

---

## 5. Task 3.3: Navigation & State Integration
**Objetivo:** Conectar a tela de histórico ao fluxo principal do app.

- **Bottom Navigation:** Mapear o segundo ícone da barra inferior para realizar a troca de tela (Index 1).
- **Persistência do Estado:** Garantir que ao voltar para a tela de histórico, os dados sejam recarregados para refletir registros feitos segundos antes na tela de Tracker.

---

## 6. Critérios de Aceite (QA)
- [ ] A lista de histórico exibe apenas a data e o total por dia (ex: 20 de Out | 5).
- [ ] O card de "Total de Pensamentos" exibe a soma correta de todos os registros.
- [ ] O layout respeita o arredondamento de bordas de 28.0 pixels para cards.
- [ ] A transição entre abas (Tracker/History) é fluida e mantém o estilo visual consistente.
- [ ] O app utiliza as cores `AppColors.primary` para números de destaque e `AppColors.neutral` para rótulos.