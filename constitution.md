# 📜 Constitution.md - Bunny hoops

## 1. Visão Geral
O **Bunny hoops** é um aplicativo de monitoramento de pensamentos focado em bem-estar e saúde mental. O projeto utiliza a estética "Bunny Core Romantic" e prioriza a escalabilidade, testabilidade e manutenibilidade através de padrões rigorosos de desenvolvimento em Flutter.

## 2. Pilares Técnicos (Tech Stack)
* **Framework:** Flutter
* **Gerenciamento de Estado:** Riverpod (utilizando Code Generation)
* **Arquitetura:** MVVM (Model-View-ViewModel) + Clean Architecture
* **Persistência Local:** Hive ou Isar (para monitoramento offline)
* **Qualidade:** Clean Code, D.R.Y (Don't Repeat Yourself) e Linter rígido.

## 3. Direcionamento de Design (Bunny Core Romantic)
Seguir estritamente o Spec Kit para manter a identidade visual:
* **Cores Principais:**
    * Primary (Pink): `#FFB7CE`
    * Secondary (Orange): `#FF8C42`
    * Background (Cream): `#FFFDF5`
    * Text (Grey): `#8D7B7B`
* **Tipografia:** Plus Jakarta Sans.
* **Componentização:** Design Atômico. Widgets devem ser pequenos e independentes.
* **Shapes:** Bordas arredondadas (Radius mínimo de `28.0` para cards e `50.0` para botões).

## 4. Padronização de Código

### 4.1 Constantes e Organização
É PROIBIDO O USO DE VALORES "HARD-CODED" (números ou strings soltas) NOS ARQUIVOS DE UI.
* **Strings:** DEVEM estar localizadas em `lib/core/constants/app_strings.dart`.
* **Medidas (Spacing/Radius):** DEVEM estar localizadas em `lib/core/constants/app_values.dart`.
* **Cores:** DEVEM estar localizadas em `lib/core/theme/app_colors.dart`.

### 4.2 Clean Code & Linter
* Seguir as regras do `flutter_lints`.
* Nomes de métodos e variáveis sempre em **Inglês**.
* Comentários apenas onde a lógica for extremamente complexa.
* Funções devem ser curtas e ter apenas uma responsabilidade (SRP).

## 5. Arquitetura de Estado (Riverpod)
* Utilizar as annotations `@riverpod` e o comando `build_runner`.
* **ViewModels:** Devem estender `_$NameNotifier` e não devem ter dependência de `BuildContext`.
* **Views:** Devem ser `ConsumerWidget` ou `ConsumerStatefulWidget`.

## 6. Testes e Persistência
* **Testes:** Toda lógica de negócio nas ViewModels deve ter testes unitários.
* **Persistência:** Implementar um repositório abstrato para o armazenamento local, permitindo troca fácil de engine (Hive/Isar) se necessário.

## 7. Estrutura de Pastas
```text
lib/
 ├── core/
 │    ├── constants/        # Strings, Dimensões e Assets
 │    ├── theme/            # Tema global e AppColors
 │    └── widgets/          # Componentes globais/atômicos (Reutilizáveis)
 ├── features/              # Organização por funcionalidade
 │    ├── tracker/
 │    │    ├── models/
 │    │    ├── views/
 │    │    └── view_models/
 │    └── history/
 ├── data/                  # Camada de Dados
 │    ├── repositories/     # Implementações de Repositórios
 │    └── datasources/      # Local Storage (Hive/Isar)
 └── main.dart