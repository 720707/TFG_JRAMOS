import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * SnackBar para mostrar mensajes informativos
///

class MiSnackBar {
  MiSnackBar._();

  static informacionSnackBar(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
