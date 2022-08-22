import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import '../../../../datos/datos.dart';
import '../../../widgets/widgets.dart';
import 'listado_listas_asistencia.dart';

///Autor: Javier Ramos Marco
/// * Vista de las listas de asistencia de una asignatura
///

class ConsultaListasAsistenciaVista extends StatefulWidget {
  Asignatura _asignatura;
  final UsuarioAutenticado _usuario;
  ConsultaListasAsistenciaVista(
      {required Asignatura asignatura,
      required UsuarioAutenticado usuario,
      Key? key})
      : _asignatura = asignatura,
        _usuario = usuario,
        super(key: key);

  @override
  State<ConsultaListasAsistenciaVista> createState() =>
      _ConsultaListasAsistenciaVistaState();
}

class _ConsultaListasAsistenciaVistaState
    extends State<ConsultaListasAsistenciaVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(
        titulo: "Asistencias: ${widget._asignatura.nombreAsignatura}",
        ruta: opcionesAsignaturasRuta,
        argumentos: ArgumentosPantalla(
            asignatura: widget._asignatura, usuario: widget._usuario),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ListasAsistenciaBloc, EstadoListasAsistencia>(
            listener: (context, state) {
              if (state is ListasAsistenciasError) {
                MiSnackBar.informacionSnackBar(context, textoExcepcionGenerica);
              }
            },
          ),
          BlocListener<AsignaturaBloc, EstadoAsignatura>(
            listener: (context, state) {
              if (state is ListaAsistenciasActualizada) {
                context
                    .read<AsignaturaBloc>()
                    .add(ObtenerAsignaturas(idUsuario: widget._usuario.id));
              } else if (state is AsignaturaError) {
                MiSnackBar.informacionSnackBar(context, textoExcepcionGenerica);
              } else if (state is AsignaturasUsuarioObtenidas) {
                //Actualizamos las asignaturas cuando se editan las listas de asistencia
                setState(() {
                  for (var asignatura in state.asignaturas) {
                    if (asignatura.idAsignatura
                            .compareTo(widget._asignatura.idAsignatura) ==
                        0) {
                      widget._asignatura = asignatura;
                    }
                  }
                });
              }
            },
          ),
        ],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Expanded(
                  child: widget._asignatura.listasAsistenciasMes.isEmpty
                      ? const Center(
                          child: Text(textoNoHayListas),
                        )
                      : ListadoListasAsistencia(
                          listasAsistencia:
                              widget._asignatura.listasAsistenciasMes,
                          usuario: widget._usuario,
                          asignatura: widget._asignatura,
                        ))
            ]),
          ),
        ),
      ),
    );
  }
}
