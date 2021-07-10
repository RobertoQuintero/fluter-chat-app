import 'dart:convert';

class Usuario {
  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    required this.uid,
  });

  bool online;
  String nombre;
  String email;
  String uid;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
      };
}
