import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Widget de la asignatura con el nombre y la opcion de borrarla al
/// * desplazar a la izquierda
///

class WidgetAsignatura extends StatelessWidget {
  const WidgetAsignatura({
    Key? key,
    required UsuarioAutenticado usuario,
    required void Function({required String idAsignatura}) eliminarAsignatura,
    required Asignatura asignatura,
  })  : _usuario = usuario,
        _asignatura = asignatura,
        _eliminarAsignatura = eliminarAsignatura,
        super(key: key);

  final UsuarioAutenticado _usuario;
  final void Function({required String idAsignatura}) _eliminarAsignatura;
  final Asignatura _asignatura;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) =>
                _eliminarAsignatura(idAsignatura: _asignatura.idAsignatura),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever_rounded,
            label: 'Borrar',
          ),
        ]),
        child: ListTile(
          title: Text(
              "${_asignatura.nombreAsignatura} - ${_asignatura.nombreGrado}"),
          onTap: () {
            Navigator.of(context).pushNamed(
              opcionesAsignaturasRuta,
              arguments: ArgumentosPantalla(
                  asignatura: _asignatura, usuario: _usuario),
            );
          },
        ),
      ),
    );
  }
}
