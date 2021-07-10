import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosPage extends StatefulWidget {
  static const routeName = 'usuarios';

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test@test.com', online: true),
    Usuario(uid: '2', nombre: 'Carlos', email: 'test1@test.com', online: false),
    Usuario(uid: '3', nombre: 'Andrea', email: 'test2@test.com', online: true),
  ];

  Future _cargarUsuarios() async {
    await Future.delayed(Duration(seconds: 3), () {
      print('hello');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.check_circle, color: Colors.blue[400]))
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
    );
  }
}
