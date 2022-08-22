import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Widget de appBar (barra superior de la vista)
///

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _titulo;
  final String _ruta;
  final Object? argumentos;

  const MiAppBar({
    required String titulo,
    required String ruta,
    this.argumentos,
    Key? key,
  })  : _titulo = titulo,
        _ruta = ruta,
        super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(_titulo),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () =>
            Navigator.of(context).popAndPushNamed(_ruta, arguments: argumentos),
      ),
    );
  }
}
