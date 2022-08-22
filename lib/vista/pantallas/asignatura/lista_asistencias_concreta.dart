import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configuracion/configuracion.dart';
import '../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import '../../../datos/datos.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista de una lista de asistencia
///

class ListaAsistenciaConcretaVista extends StatefulWidget {
  final ListaAsistenciasDia _listaAsistencias;
  final UsuarioAutenticado _usuario;
  final Asignatura _asignatura;
  final bool editable;
  const ListaAsistenciaConcretaVista(
      {required ListaAsistenciasDia listaAsistencias,
      required UsuarioAutenticado usuario,
      required Asignatura asignatura,
      this.editable = false,
      Key? key})
      : _listaAsistencias = listaAsistencias,
        _usuario = usuario,
        _asignatura = asignatura,
        super(key: key);

  @override
  State<ListaAsistenciaConcretaVista> createState() =>
      _ListaAsistenciaConcretaVistaState();
}

class _ListaAsistenciaConcretaVistaState
    extends State<ListaAsistenciaConcretaVista> {
  @override
  void initState() {
    super.initState();
  }

  cambiarAsistencia(Alumno alumno) {
    setState(() {
      if (alumno.presente) {
        alumno.presente = false;
      } else {
        alumno.presente = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(
        titulo: tituloListadoAsistencias,
        ruta: listasAsistenciasAsignaturaRuta,
        argumentos: ArgumentosPantalla(
            usuario: widget._usuario, asignatura: widget._asignatura),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              MultiBlocListener(
                listeners: [
                  BlocListener<ListasAsistenciaBloc, EstadoListasAsistencia>(
                      listener: (context, state) {
                    if (state is ListaAsistenciasEditada) {
                      MiSnackBar.informacionSnackBar(
                          context, textoListaAsistenciaEditada);
                      context.read<AsignaturaBloc>().add(
                            EditarListaEnAsignatura(
                                listaAsistenciasMesSinEditar:
                                    state.listaAsistenciasMesSinEditar,
                                asignatura: widget._asignatura),
                          );
                      Navigator.of(context).popAndPushNamed(
                          listasAsistenciasAsignaturaRuta,
                          arguments: ArgumentosPantalla(
                              usuario: widget._usuario,
                              asignatura: widget._asignatura));
                    }
                  }),
                  BlocListener<AsignaturaBloc, EstadoAsignatura>(
                      listener: (context, state) {
                    if (state is ListaAsistenciasEditadaEnAsignatura) {
                      Navigator.of(context).popAndPushNamed(
                          listasAsistenciasAsignaturaRuta,
                          arguments: ArgumentosPantalla(
                              usuario: widget._usuario,
                              asignatura: widget._asignatura));
                    }
                    if (state is AsignaturaError) {
                      MiSnackBar.informacionSnackBar(context, state.mensaje);
                    }
                  })
                ],
                child: Expanded(
                  child: ListView(
                    children: widget._listaAsistencias.alumnos.map((alumno) {
                      final estaSeleccionado = alumno.presente;
                      return Card(
                        child: MiListTileIconosCambiables(
                          key: Key(alumno.nipAlumno),
                          alumno: alumno,
                          alumnoPresente: estaSeleccionado,
                          enAlumnoSeleccionado: cambiarAsistencia,
                          editable: widget.editable,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              (widget.editable)
                  ? ElevatedButton(
                      onPressed: () {
                        context.read<ListasAsistenciaBloc>().add(EditarListaDia(
                            listaAsistenciasDia: widget._listaAsistencias));
                      },
                      child: const Text("Aceptar"))
                  : const Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
