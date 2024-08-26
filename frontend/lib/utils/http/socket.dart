import 'package:socket_io_client/socket_io_client.dart' as io;

class MySocketHelper {
  connectToServer() {
    try {
      io.Socket socket = io.io('http://127.0.0.1:4000/websocket/order', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      print('Conectando ao servidor...');
      socket.connect();

      socket.on('connect', (_) {
        print('Conectado ao servidor');

      });

      socket.on('disconnect', (_) {
        print('Desconectado do servidor');
      });
    } catch (e) {
      print('Não foi possível conectar ao servidor: $e');
    }
  }
}