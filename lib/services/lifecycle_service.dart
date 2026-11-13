
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifecycleService with WidgetsBindingObserver {
  final void Function(String estado, String? ultimoHorario)
      onEstadoAlterado;

  LifecycleService({required this.onEstadoAlterado});

  void iniciar() {
    WidgetsBinding.instance.addObserver(this);
    carregarHorario();
  }

  Future<void> carregarHorario() async {
    final prefs = await SharedPreferences.getInstance();
    onEstadoAlterado(
      'Aplicativo iniciado',
      prefs.getString('ultimoBackground'),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onEstadoAlterado('App em foreground', null);
        break;

      case AppLifecycleState.inactive:
        onEstadoAlterado('App inativo', null);
        break;

      case AppLifecycleState.paused:
        onEstadoAlterado('App em background', null);
        salvarHorario();
        break;

      case AppLifecycleState.detached:
        onEstadoAlterado('App detached', null);
        break;

      case AppLifecycleState.hidden:
        onEstadoAlterado('App hidden', null);
        break;
    }
  }

  Future<void> salvarHorario() async {
    final horario = DateTime.now().toString();
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('ultimoBackground', horario);
    onEstadoAlterado('App em background', horario);
  }

  void encerrar() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
