import '../../../datos/entidades/usuario_autenticado.dart';
import '../../widgets/menus/popup_menu_opciones.dart';
import 'calendario_vista.dart';

import '../../../configuracion/configuracion.dart';

import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Vista del calendario y las clases
///

class CalendarioyClasesVista extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  const CalendarioyClasesVista({required UsuarioAutenticado usuario, Key? key})
      : _usuario = usuario,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(tituloVistaCalendario),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuOpciones(usuario: _usuario),
        ],
      ),
      body: CalendarioVista(usuario: _usuario),
    );
  }
}
