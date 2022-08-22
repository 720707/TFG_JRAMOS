import 'package:flutter/material.dart';

import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Widget de list tile con iconos
///

class MiListTileIconosCambiables extends StatelessWidget {
  final Alumno alumno;
  final bool alumnoPresente;
  final ValueChanged<Alumno> enAlumnoSeleccionado;
  final bool editable;

  const MiListTileIconosCambiables(
      {Key? key,
      required this.alumnoPresente,
      required this.alumno,
      required this.enAlumnoSeleccionado,
      required this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(alumno.nombreCompleto),
        subtitle: Text(alumno.nipAlumno),
        onTap: () => editable ? enAlumnoSeleccionado(alumno) : null,
        trailing: alumnoPresente
            ? const Icon(Icons.check_circle_outline, color: Colors.green)
            : const Icon(Icons.cancel_outlined, color: Colors.red),
      ),
    );
  }
}
