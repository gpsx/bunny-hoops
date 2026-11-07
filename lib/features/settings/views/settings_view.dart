import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/history_export_service.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../../../data/repositories/settings_repository.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSync = ref.read(settingsRepositoryProvider).getLastCloudSync();
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_done_outlined),
            title: const Text('Sincronização em nuvem'),
            subtitle: Text(
              lastSync == null
                  ? 'Aguardando primeira sincronização'
                  : 'Última sincronização: ${lastSync.toLocal()}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: const Text('Exportar histórico'),
            subtitle: const Text('Salve uma cópia JSON fora do app'),
            onTap: () async {
              try {
                await HistoryExportService(
                  ref.read(thoughtRepositoryProvider),
                ).shareExport();
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Falha ao exportar histórico: $error')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file_rounded),
            title: const Text('Importar histórico'),
            subtitle:
                const Text('Mescla um backup JSON sem apagar mensagens atuais'),
            onTap: () async {
              try {
                final count = await HistoryExportService(
                  ref.read(thoughtRepositoryProvider),
                ).importBackup();
                if (!context.mounted || count == 0) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$count pensamentos importados.')),
                );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Falha ao importar histórico: $error')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
