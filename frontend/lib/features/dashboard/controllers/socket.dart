import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/controllers/create_order_controller.dart';
import 'package:frontend/utils/helpers/helper_functions.dart';
import 'package:frontend/utils/localStorage/storage_utility.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MySocketHelper {
  void Function(dynamic) callbackOrder = (dynamic order) {};

  Future initialize() async {
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:4000/websocket/order'),
      );
      await channel.ready;

      final tk = await MyLocalStorage().readData('@rs:progapp_tk');

      dynamic dataListen = {"accessToken": tk, "command": "listen"};

      channel.sink.add(jsonEncode(dataListen));

      channel.stream.listen((data) {
        //print("TAKEDA");
        //print(data);
        receviedOrder(json.decode(data));
      });
    } on SocketException catch (e) {
      // Handle the exception.
      print(e);
    } on WebSocketChannelException catch (e) {
      // Handle the exception.
      print(e);
    }

    /*
    final orderController = Get.put(CreateOrderController());

    try {
      IO.Socket socket = IO.io('http://127.0.0.1:4000', <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      });
      final tk = await MyLocalStorage().readData('@rs:progapp_tk');
      socket.io.options?['extraHeaders'] = {'authorization': tk};
      print(tk);
      socket.connect();
      socket.onConnect((_) {
        print('Connection established');
      });
      socket.onDisconnect((_) => print('Connection Disconnection'));
      socket.onConnectError((err) => print(err));
      socket.onError((err) => print(err));
      socket.on('new_order', (_) async {
        await orderController.getOrders();
        MyHelperFunctions.showSnackBar('Atualizando pedidos...', "Green");
      });
    } catch (e) {
      print('Não foi possível conectar ao servidor: $e');
    }
    */
  }

  void onOrder(void Function(dynamic) callback) {
    callbackOrder = callback;
  }

  void receviedOrder(dynamic order) {
    callbackOrder(order);
  }
}
