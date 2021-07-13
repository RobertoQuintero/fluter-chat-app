import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  static const routeName = 'chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  ChatService chatService = ChatService();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escuchaMensaje);
    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat
        .map((m) => ChatMessage(
            texto: m.mensaje,
            uid: m.de,
            animationController: AnimationController(
                vsync: this, duration: Duration(milliseconds: 0))
              ..forward()))
        .toList();

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escuchaMensaje(dynamic payload) {
    ChatMessage message = new ChatMessage(
        texto: payload['mensaje'],
        uid: payload['uid'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  _handleSubmit() {
    if (_textController.text.length == 0) return;
    final newMessage = ChatMessage(
        uid: authService.usuario!.uid,
        texto: _textController.text,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario?.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': _textController.text
    });
    setState(() {});
    _estaEscribiendo = false;
    _textController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(usuarioPara.nombre.substring(0, 2),
                    style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text(usuarioPara.nombre,
                  style: TextStyle(color: Colors.black87, fontSize: 12))
            ],
          )),
      body: Container(
          child: Column(
        children: [
          Flexible(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, i) => _messages[i],
            reverse: true,
            itemCount: _messages.length,
          )),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      )),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: (_) {},
              onChanged: (texto) {
                if (texto.trim().length > 0) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
                setState(() {});
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo ? _handleSubmit : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo ? _handleSubmit : null,
                        ),
                      )))
        ],
      ),
    ));
  }
}
