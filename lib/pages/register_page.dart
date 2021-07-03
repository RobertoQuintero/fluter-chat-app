import 'package:flutter/material.dart';

import 'package:chat/widgets/Logo.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = 'register';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Registro',
                ),
                _Form(),
                Labels(
                  route: 'login',
                ),
                Text('Términos y condiciones de uso',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ))
              ]),
        ),
      )),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passwordController,
            isPassword: true,
          ),
          BotonAzul(
            title: 'Registrarse',
            callback: () {
              print(emailController.text);
              print(passwordController.text);
            },
          )
        ],
      ),
    );
  }
}
