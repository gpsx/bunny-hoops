# 📜 Epic 02: Tracker Home Screen - Bunny Core UI & Logic

## 1. Visão Geral
Este épico cobre o desenvolvimento da tela principal (Tracker), onde o usuário interage com o botão central de coelho para registrar pensamentos. Inclui a lógica de estado, persistência local e a criação de componentes customizados baseados na interface "Bunny Core".

---

## 2. Funcionalidades Detalhadas
- **Contador Diário:** Exibição proeminente do total de pensamentos do dia atual.
- **Botão de Registro:** Botão central circular com ícone de coelho que incrementa o contador ao ser pressionado.
- **Card de Última Entrada:** Exibe o horário (HH:mm) do último registro realizado.
- **Card de Streak:** Exibe a contagem de dias consecutivos de uso do app.
- **Navegação:** Bottom Navigation Bar customizada para alternar entre 'Tracker' e 'History'.

---

## 3. Task 2.1: Data Model & Repository (Persistence)
**Objetivo:** Criar a estrutura de dados e o contrato de armazenamento via Hive.

### lib/features/tracker/models/thought_model.dart
```dart
import 'package:hive/hive.dart';

part 'thought_model.g.dart';

@HiveType(typeId: 0)
class Thought extends HiveObject {
  @HiveField(0)
  final DateTime createdAt;

  Thought({required this.createdAt});
}
lib/data/repositories/thought_repository.dart
Dart
import '../models/thought_model.dart';

abstract class ThoughtRepository {
  Future<void> saveThought(Thought thought);
  List<Thought> getThoughtsByDay(DateTime date);
  int calculateStreak();
}
4. Task 2.2: ViewModel (Riverpod Logic)
Objetivo: Gerenciar o estado da tela, cálculos de métricas e chamadas ao repositório.

lib/features/tracker/view_models/tracker_view_model.dart
Dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/thought_model.dart';

part 'tracker_view_model.g.dart';

@riverpod
class TrackerViewModel extends _$TrackerViewModel {
  @override
  FutureOr<TrackerState> build() async {
    return _fetchCurrentStats();
  }

  Future<void> recordNewThought() async {
    state = const AsyncLoading();
    // Lógica: Salvar no Hive -> Recalcular Stats -> Atualizar State
    final thought = Thought(createdAt: DateTime.now());
    await ref.read(thoughtRepositoryProvider).saveThought(thought);
    state = AsyncData(await _fetchCurrentStats());
  }

  Future<TrackerState> _fetchCurrentStats() async {
    // Implementação da busca de dados no repositório
    return TrackerState(count: 0, streak: 0, lastEntry: "--:--");
  }
}

class TrackerState {
  final int count;
  final int streak;
  final String lastEntry;
  TrackerState({required this.count, required this.streak, required this.lastEntry});
}
5. Task 2.3: Atomic UI Components
Objetivo: Criar widgets reutilizáveis e isolados conforme o Constitution.md.

lib/core/widgets/daily_counter_display.dart
Widget que desenha o ícone de coração e o número grande (Daily Total).

Deve usar GoogleFonts.plusJakartaSans com peso ExtraBold.

lib/core/widgets/bunny_record_button.dart
Botão circular com gradiente suave ou cor sólida AppColors.primary.

Ícone de coelho centralizado e label "Record Thought" abaixo.

lib/core/widgets/metric_card.dart
Card com AppSizes.rCard (28.0).

Layout: Ícone no topo esquerdo, Label secundário e Valor principal.

lib/core/widgets/amanda_bottom_nav.dart
Barra inferior com bordas superiores arredondadas e ícones estilizados.

6. Task 2.4: Main View Assembly
Objetivo: Montar a tela TrackerView utilizando os componentes criados.

lib/features/tracker/views/tracker_view.dart
Dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_values.dart';
import '../../../core/widgets/bunny_record_button.dart';
import '../view_models/tracker_view_model.dart';

class TrackerView extends ConsumerWidget {
  const TrackerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trackerViewModelProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
        child: Column(
          children: [
            const DailyCounterDisplay(),
            const Spacer(),
            BunnyRecordButton(
              onPressed: () => ref.read(trackerViewModelProvider.notifier).recordNewThought(),
            ),
            const Spacer(),
            _buildMetricsRow(),
            const SizedBox(height: AppSizes.p32),
          ],
        ),
      ),
      bottomNavigationBar: const AmandaBottomNav(),
    );
  }
}
7. Checklist de Conclusão
[ ] Model Thought gerado e registrado no Hive.

[ ] ViewModel gerencia o incremento do contador sem lógica na View.

[ ] Botão de Coelho segue o design (Cor Primary, ícone centralizado).

[ ] Cards de métrica utilizam o AppSizes.rCard.

[ ] Teste unitário criado para validar o cálculo do Streak na ViewModel.