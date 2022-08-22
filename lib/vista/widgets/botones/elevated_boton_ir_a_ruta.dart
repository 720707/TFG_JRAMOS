import 'package:flutter/material.dart';

import '../../../datos/modelos/argumentos_pantalla.dart';

///Autor: Javier Ramos Marco
/// * ElevatedButton para ir a una pantalla
///

class ElevatedBotonIrARuta extends StatelessWidget {
  final String _ruta;
  final String _texto;
  final ArgumentosPantalla? argumentos;
  const ElevatedBotonIrARuta({
    required String ruta,
    required String texto,
    this.argumentos,
    Key? key,
  })  : _texto = texto,
        _ruta = ruta,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          Navigator.of(context).pushNamed(_ruta, arguments: argumentos),
      child: Text(_texto),
    );
  }
}
