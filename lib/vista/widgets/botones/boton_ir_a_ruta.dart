import 'package:flutter/material.dart';

import '../../../datos/modelos/argumentos_pantalla.dart';

///Autor: Javier Ramos Marco
/// * Widget para moverse a una pantalla
///

class BotonIrARuta extends StatelessWidget {
  final String _ruta;
  final String _texto;
  final ArgumentosPantalla? argumentos;
  const BotonIrARuta({
    required String ruta,
    required String texto,
    this.argumentos,
    Key? key,
  })  : _texto = texto,
        _ruta = ruta,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(_ruta),
      child: Text(_texto),
    );
  }
}
