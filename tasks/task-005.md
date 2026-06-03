# 📜 Epic 05: Dynamic Notifications & App Branding

## 1. Visão Geral
Este épico foca na implementação de um sistema de notificações locais inteligentes e na finalização da identidade visual do app (Branding). O sistema de notificações será dinâmico, alternando o conteúdo (título e ícones) com base em um seletor de "Personagem/Ícone" na tela principal e permitindo mensagens personalizadas.

---

## 2. Funcionalidades e Regras de Negócio

### 2.1 Seletor de Personagem (Dado vs Coelho)
- **UI:** Adição de um botão alternável no canto superior direito da tela `Tracker`.
- **Persistência:** A escolha do ícone deve ser salva imediatamente no Local Storage (Hive).
- **Lógica de Notificação (Regra 1):**
    - Se **Dado** selecionado: Notificação enviada quando o perfil "Coelho" registrar um pensamento. 
        - *Título:* "Amandinha esta pensando em vc ❤️🐰🤘"
    - Se **Coelho** selecionado: Notificação enviada quando o perfil "Dado" registrar um pensamento.
        - *Título:* "Sarky esta pensando em vc ❤️🦦🤘"

### 2.2 Mensagem Customizada (Regra 2)
- **UI:** Adição de um campo de texto (`TextField`) estilizado abaixo do botão principal "Record Thought".
- **Lógica de Envio:**
    - Se o campo estiver vazio/nulo: Enviar descrição padrão: *"Oi meu amor tava pensando em vc agorinha, te amo mt"*.
    - Se o campo estiver preenchido: Enviar o texto digitado como descrição da notificação.
    - **Exceção Widget:** Registros feitos via Widget sempre enviam a descrição padrão.

---

## 3. Task 5.1: Branding & Identity Updates
**Objetivo:** Ajustar o nome e o ícone do aplicativo para refletir a nova fase do projeto.

- **Nome do App:** Alterar o `label` do aplicativo de `bunny_hoops` para `"Bunny Hoops"` (com espaço e capitalização correta) no `AndroidManifest.xml` e `Info.plist`.
- **App Icon:** Substituir o ícone padrão do Flutter por um emoji de coelho estilizado. Gerar as densidades necessárias (hdpi, xhdpi, etc) usando a paleta `AppColors.primary`.

---

## 4. Task 5.2: UI Updates (Header & Input)
**Objetivo:** Implementar os novos elementos visuais na `TrackerView` baseados nas imagens de referência.

- **Toggle Button (Top Left):** Criar um botão que alterna entre o ícone de um **Dado** e um **Coelho**. Utilizar animação simples de troca.
- **Custom Message Input:** - Implementar o `TextField` seguindo a imagem de referência (bordas arredondadas, fundo leve `AppColors.primary.withOpacity(0.1)`).
    - Hint text: *"Escreva uma mensagem..."*.
    - Estilo da fonte: `Plus Jakarta Sans`.

---

## 5. Task 5.3: Notification Logic & Provider
**Objetivo:** Desenvolver o serviço de notificação local e a lógica de inversão de perfil.

- **Service Setup:** Configurar o `flutter_local_notifications`.
- **LocalStorage Integration:** Criar uma chave `active_profile` no Hive para salvar a escolha do seletor.
- **Payload Logic:**
    - Criar uma função que verifica o perfil ativo e prepara o `NotificationPayload`.
    - Implementar a condição: "Se profile == Dado, Título = Amandinha; Se profile == Coelho, Título = Sarky".
    - Validar o conteúdo do `TextController` para definir o `body` da notificação.

---

## 6. Task 5.4: Widget & Background Integration
**Objetivo:** Garantir que o Widget Android respeite as novas regras.

- **Widget Override:** Ajustar a função de background do Widget para ignorar o campo de texto da UI e disparar a notificação sempre com a "Descrição Padrão".

---

## 7. Critérios de Aceite (QA)
- [ ] O nome do app aparece como "Bunny Hoops" no launcher do celular.
- [ ] O ícone do app é o emoji de coelho configurado.
- [ ] Ao trocar o ícone no topo direito, a escolha persiste após fechar e abrir o app.
- [ ] Ao registrar um pensamento com o ícone do **Dado** ativo, a notificação recebida tem o título da "Amandinha".
- [ ] Ao registrar um pensamento pela tela principal, limpar o campo de texto.
- [ ] Ao escrever "Bom dia!" no campo de texto, a notificação recebida exibe "Bom dia!" na descrição.
- [ ] Se o campo estiver vazio, a notificação exibe a frase padrão: "Oi meu amor tava pensando em vc...".
- [ ] Registros via Widget ignoram o que está escrito no campo de texto e enviam o padrão.