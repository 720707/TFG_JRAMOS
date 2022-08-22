import 'package:flutter/material.dart';

import '../../../datos/datos.dart';
import '../../pantallas/clase/pasar_lista_clase_vista.dart';
import '../ListTile/mi_listTile_iconos_cambiables.dart';

///Autor: Javier Ramos Marco
/// * Widget para listar los alumnos
///

class ListadoAlumnos extends StatelessWidget {
  final Clase _clase;
  const ListadoAlumnos({
    Key? key,
    required Clase clase,
    required this.widget,
    required this.enAlumnoSeleccionado,
  })  : _clase = clase,
        super(key: key);

  final PasarListaEnClaseVista widget;

  final dynamic enAlumnoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: _clase.alumnos.map((alumno) {
          final estaSeleccionado = alumno.presente;
          return MiListTileIconosCambiables(
            key: Key(alumno.nipAlumno),
            alumno: alumno,
            alumnoPresente: estaSeleccionado,
            enAlumnoSeleccionado: enAlumnoSeleccionado,
            editable: true,
          );
        }).toList(),
      ),
    );
  }
}
