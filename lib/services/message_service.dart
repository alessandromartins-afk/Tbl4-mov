
import 'dart:async';

class MessageService {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get mensagens => _controller.stream;

  void enviarMensagem(String mensagem) {
    if (mensagem.trim().isEmpty) return;

    if (!_controller.isClosed) {
      _controller.add(mensagem);
    }
  }

  void simularMensagemRecebida() {
    enviarMensagem(
      'Olá! Sua mensagem foi recebida com sucesso.',
    );
  }

  Future<void> encerrar() async {
    await _controller.close();
  }
}
