# 📜 Epic 04: Android Home Screen Widget Integration

## 1. Visão Geral
Este épico foca na criação de um Widget de tela inicial para Android que permite ao usuário visualizar o progresso do dia corrente e registrar novos pensamentos rapidamente sem abrir o app completo. O widget deve reutilizar a identidade visual "Bunny Core".

---

## 2. Funcionalidades e Regras de Negócio
- **Sincronização de Dados:** O widget deve ler o banco de dados local (Hive/Isar) para exibir o total de pensamentos do dia atual.
- **Ação Rápida (Click to Record):** Ao tocar no widget, ele deve disparar uma ação de incremento no banco de dados e atualizar a interface do próprio widget.
- **Filtro Temporal:** O widget exibe estritamente os dados do "dia corrente" (resetando à meia-noite).
- **Interface Reutilizada:** O design deve espelhar o componente de coração e contador central presente no app.

---

## 3. Task 4.1: Native Bridge Setup (Android/Flutter)
**Objetivo:** Configurar a comunicação entre o Flutter e o provedor de widgets nativo do Android.

- **Dependências:** Configurar o plugin `home_widget` no `pubspec.yaml`.
- **Background Actions:** Configurar um `callbackDispatcher` no `main.dart` para processar cliques no widget mesmo com o app fechado.
- **Android Manifest:** Registrar o `HomeWidgetProvider` e definir o arquivo de layout XML para o widget.

---

## 4. Task 4.2: Data Sharing Layer (App Group / SharedPreferences)
**Objetivo:** Garantir que o código nativo consiga ler os dados salvos pelo Flutter.

- **Shared Storage:** Como o Hive é puramente Dart, utilizaremos o `home_widget` para salvar o valor atual do contador em uma área de memória compartilhada (SharedPreferences) sempre que o estado mudar no app.
- **Update Trigger:** Configurar a `TrackerViewModel` para chamar `HomeWidget.saveWidgetData` e `HomeWidget.updateWidget` sempre que um novo pensamento for registrado dentro do app.

---

## 5. Task 4.3: Widget UI & Interaction (Native Layout)
**Objetivo:** Desenvolver a interface visual do widget utilizando XML (Android) para garantir performance e compatibilidade.

- **Layout XML:** Criar o layout no Android Studio replicando:
    - O ícone de coração ao fundo.
    - O texto centralizado para o número (Daily Total).
    - A área clicável para o incremento.
- **Estilização:** Mapear as cores do Spec Kit (`#FFB7CE` e `#8D7B7B`) para o arquivo `colors.xml` do Android.

---

## 6. Task 4.4: Click-to-Record Implementation
**Objetivo:** Implementar a lógica de "Record Thought" via widget.

- **Headless Task:** Criar uma função Dart isolada que:
    1. Abre a box do Hive.
    2. Incrementa o contador.
    3. Atualiza os SharedPreferences do widget.
    4. Notifica o sistema Android para redesenhar o widget.

---

## 7. Critérios de Aceite (QA)
- [ ] O widget exibe o número exato de pensamentos registrados no dia.
- [ ] Ao clicar no widget, o número incrementa visualmente (após um pequeno delay de processamento).
- [ ] O design do widget é consistente com o componente de coração do app.
- [ ] À meia-noite, o contador do widget retorna a zero (ou conforme a primeira leitura do novo dia).
- [ ] Clicar no widget atualiza o banco de dados local do app de forma persistente.