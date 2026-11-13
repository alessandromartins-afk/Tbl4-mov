
import 'package:flutter/material.dart';

import '../services/lifecycle_service.dart';
import '../services/background_service.dart';

import 'pedido_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String estado = 'Aplicativo iniciado';
  String ultimoHorario = 'Nenhum registro';
  String resultadoSync = 'Aguardando sincronização';
  String mensagem = 'Nenhuma notificação recebida';

  bool sincronizando = false;

  late LifecycleService lifecycleService;

  @override
  void initState() {
    super.initState();

    lifecycleService = LifecycleService(
      onEstadoAlterado: (novoEstado, horario) {
        if (!mounted) return;

        setState(() {
          estado = novoEstado;

          if (horario != null) {
            ultimoHorario = horario;
          }
        });
      },
    );

    lifecycleService.iniciar();
  }

  void abrirPedido(String pedidoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PedidoPage(pedidoId: pedidoId),
      ),
    );
  }

  void simularNotificacao() {
    setState(() {
      mensagem = 'Pedido 123 saiu para entrega!';
    });

    abrirPedido('123');
  }

  void abrirChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatPage(),
      ),
    );
  }

  Future<void> executarSincronizacao() async {
    setState(() {
      sincronizando = true;
      resultadoSync = 'Sincronizando...';
    });

    try {
      if (BackgroundService.suportaWorkManager) {
        await BackgroundService.agendarSincronizacao();
      }

      final resultado =
          await BackgroundService.simularSincronizacao();

      if (!mounted) return;

      setState(() {
        resultadoSync = resultado;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        resultadoSync = 'Erro: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          sincronizando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    lifecycleService.encerrar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Computação Móvel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 25),

                const Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Exercício 1 - Lifecycle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  estado,
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 30),
                const Divider(),

                const Text(
                  'Exercício 2 - Último Background',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),
                Text(ultimoHorario),

                const SizedBox(height: 30),
                const Divider(),

                const Text(
                  'Exercício 3 - WorkManager',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: sincronizando
                      ? null
                      : executarSincronizacao,
                  child: const Text('Simular sincronização'),
                ),

                const SizedBox(height: 10),
                Text(resultadoSync),

                const SizedBox(height: 30),
                const Divider(),

                const Text(
                  'Exercício 4 - Notificações Push',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Icon(
                  Icons.notifications_active,
                  size: 60,
                  color: Colors.orange,
                ),

                const SizedBox(height: 15),

                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: simularNotificacao,
                  child: const Text('Simular notificação'),
                ),

                const SizedBox(height: 30),
                const Divider(),

                const Text(
                  'Exercício 5 - Mensagens',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Icon(
                  Icons.chat,
                  size: 60,
                  color: Colors.green,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: abrirChat,
                  child: const Text('Abrir Chat'),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
