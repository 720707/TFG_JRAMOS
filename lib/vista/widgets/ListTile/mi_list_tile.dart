import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Widget de list tile
///

class MiListTile extends StatelessWidget {
  final String _titulo;
  final void Function()? _onTap;
  final String? subTitulo;
  final Widget? trailing;

  const MiListTile(
      {required String titulo,
      required void Function()? onTap,
      this.subTitulo,
      this.trailing,
      Key? key})
      : _titulo = titulo,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_titulo),
      onTap: _onTap,
      trailing: trailing,
    );
  }
}
