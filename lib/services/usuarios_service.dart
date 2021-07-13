import 'package:chat/global/enviroment.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse('${Enviroment.apiUrl}/usuarios');
      final token = await AuthService.getToken();
      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final usuariosResponse = UsuariosResponse.fromJson(resp.body);
      print(usuariosResponse.usuarios);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
