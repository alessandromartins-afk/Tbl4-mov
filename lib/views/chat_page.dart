
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/message_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessageService messageService = MessageService();

  final TextEditingController textoController =
      TextEditingController();

  final List<String> mensagens = [];

  StreamSubscription<String>? subscription;

  @override
  void initState() {
    super.initState();

    subscription = messageService.mensagens.listen((mensagem) {
      if (!mounted) return;

      setState(() {
        mensagens.add(mensagem);
      });
    });
  }

  void enviarMensagem() {
    final texto = textoController.text.trim();

    if (texto.isEmpty) return;

    messageService.enviarMensagem('Você: $texto');
    textoController.clear();
  }

  void receberMensagem() {
    messageService.simularMensagemRecebida();
  }

  @override
  void dispose() {
    subscription?.cancel();
    textoController.dispose();
    messageService.encerrar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercício 5 - Chat'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: mensagens.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma mensagem recebida',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            mensagens[index],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: receberMensagem,
              icon: const Icon(Icons.notifications),
              label: const Text(
                'Simular mensagem recebida',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textoController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => enviarMensagem(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: enviarMensagem,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
