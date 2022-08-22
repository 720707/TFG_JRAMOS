import 'widget_asignatura.dart';

import '../../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Listado de asignaturas por año
///

class ListadoAsignaturas extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  final List<Asignatura> _asignaturas;
  const ListadoAsignaturas({
    Key? key,
    required UsuarioAutenticado usuario,
    required List<Asignatura> asignaturas,
  })  : _usuario = usuario,
        _asignaturas = asignaturas,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtenemos los años de las asignatruas para poder ordenar las asiganturas
    //por año
    List<String> anyos = [];
    for (Asignatura asignatura in _asignaturas) {
      if (!anyos.contains(asignatura.fechaInicio.year.toString())) {
        anyos.add(asignatura.fechaInicio.year.toString());
      }
    }

    void eliminarAsignatura({required String idAsignatura}) {
      context.read<AsignaturaBloc>().add(EliminarAsignatura(
          idAsignatura: idAsignatura, idUsuario: _usuario.id));
    }

    return Expanded(
      child: ListView(
          children: anyos.reversed.map((anyo) {
        return Card(
            child: ListTile(
          title: ExpansionTile(
            title: Text(anyo),
            children: [
              BlocListener<AsignaturaBloc, EstadoAsignatura>(
                listener: (context, state) {
                  if (state is AsignaturaEliminadaCorrectamente) {
                    context.read<ListasAsistenciaBloc>().add(
                        EliminarListasAsistenciaDiayMes(
                            idAsignatura: state.idAsignatura));
                  }
                },
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  children: _asignaturas.map((asignatura) {
                    if (asignatura.fechaInicio.year.toString() == anyo) {
                      return WidgetAsignatura(
                        usuario: _usuario,
                        key: Key(asignatura.idAsignatura),
                        eliminarAsignatura: eliminarAsignatura,
                        asignatura: asignatura,
                      );
                    } else {
                      return const Card();
                    }
                  }).toList(),
                ),
              )
            ],
          ),
        ));
      }).toList()),
    );
  }
}
