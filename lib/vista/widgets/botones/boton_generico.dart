import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Widget de boton generico
///

class BotonGenerico extends StatelessWidget {
  final String _texto;
  final void Function()? _onPressed;
  final Icon? icono;
  const BotonGenerico({
    Key? key,
    required void Function()? onPressed,
    this.icono,
    required String texto,
  })  : _texto = texto,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(_texto),
    );
  }
}
