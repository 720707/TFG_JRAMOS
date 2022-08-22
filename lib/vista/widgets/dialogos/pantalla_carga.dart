import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Widget que muestra un circulo de carga
///

class PantallaCarga extends StatelessWidget {
  const PantallaCarga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
