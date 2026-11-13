
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

const String tarefaSincronizacao = 'sincronizarDados';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Executando tarefa: $task');

    await Future.delayed(
      const Duration(seconds: 3),
    );

    debugPrint('Sincronização concluída!');
    return true;
  });
}

class BackgroundService {
  static bool get suportaWorkManager =>
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android;

  static Future<void> iniciar() async {
    if (!suportaWorkManager) return;

    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> agendarSincronizacao() async {
    if (!suportaWorkManager) return;

    await Workmanager().registerPeriodicTask(
      'syncTask',
      tarefaSincronizacao,
      frequency: const Duration(minutes: 15),
    );
  }

  static Future<String> simularSincronizacao() async {
    debugPrint('Iniciando sincronização fake...');

    await Future.delayed(
      const Duration(seconds: 3),
    );

    debugPrint('Sincronização fake concluída!');

    return 'Sincronização concluída com sucesso!';
  }
}
