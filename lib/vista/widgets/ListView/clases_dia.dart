import '../../../datos/entidades/usuario_autenticado.dart';
import '../../../datos/modelos/argumentos_pantalla.dart';

import '../../../configuracion/constantes/rutas.dart';

import 'package:flutter/material.dart';

import '../../../datos/entidades/clase.dart';

///Autor: Javier Ramos Marco
/// * Widget para mostrar las clases de un dia
///

class ClasesDia extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  const ClasesDia({
    Key? key,
    required UsuarioAutenticado usuario,
    required this.eventosSeleccionados,
  })  : _usuario = usuario,
        super(key: key);

  final List<Clase> eventosSeleccionados;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventosSeleccionados.length,
      itemBuilder: (BuildContext context, int index) {
        Clase clase = eventosSeleccionados[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            trailing: const Icon(Icons.playlist_add_check_rounded),
            onTap: () => {
              Navigator.of(context).pushNamed(pasarListaClaseRuta,
                  arguments:
                      ArgumentosPantalla(clase: clase, usuario: _usuario)),
            },
            title: Text(clase.nombreAsignatura),
            enabled: !clase.listaPasada,
          ),
        );
      },
    );
  }
}
