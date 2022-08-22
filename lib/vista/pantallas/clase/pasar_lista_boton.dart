//Ponerlo fuera
import 'package:control_asistencia_tfg_jrm/vista/pantallas/clase/pasar_lista_clase_vista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Boton para pasar lista
///

class PasarLista extends StatelessWidget {
  const PasarLista({
    Key? key,
    required this.widget,
    required Clase clase,
  })  : _clase = clase,
        super(key: key);

  final PasarListaEnClaseVista widget;
  final Clase _clase;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String idListaAsistencia = _clase.idClase +
            _clase.diaClase.day.toString() +
            _clase.diaClase.month.toString();
        ListaAsistenciasDia listaAsistencias = ListaAsistenciasDia(
            fecha: _clase.diaClase,
            idAsignatura: _clase.idAsignatura,
            alumnos: _clase.alumnos,
            idListaAsistenciasDia: idListaAsistencia);

        context.read<ListasAsistenciaBloc>().add(PasarListaDia(
            listaAsistenciasDia: listaAsistencias, clase: _clase));
      },
      child: const Text('Pasar Lista'),
    );
  }
}
