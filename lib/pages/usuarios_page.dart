import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosPage extends StatefulWidget {
  static const routeName = 'usuarios';

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = UsuariosService();
  List<Usuario> usuarios = [];
  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  Future _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuarios();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario!.nombre,
            style: TextStyle(color: Colors.black54),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black54),
            onPressed: () {
              //desconectarnos del socket
              socketService.disconnect();
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child: socketService.serverStatus == ServerStatus.Online
                    ? Icon(Icons.check_circle, color: Colors.blue[400])
                    : Icon(Icons.offline_bolt, color: Colors.red))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _cargarUsuarios,
          child: ListView.separated(
              itemBuilder: (_, i) => _UsuarioListTile(usuario: usuarios[i]),
              separatorBuilder: (_, i) => Divider(),
              itemCount: usuarios.length),
        ));
  }
}

class _UsuarioListTile extends StatelessWidget {
  const _UsuarioListTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(50)),
      ),
      onTap: () {
        Provider.of<ChatService>(context, listen: false).usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
