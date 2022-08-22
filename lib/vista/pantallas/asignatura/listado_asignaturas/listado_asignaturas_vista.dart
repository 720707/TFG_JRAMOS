import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import '../../../../datos/datos.dart';
import '../../../widgets/widgets.dart';
import 'listado_asignaturas_widget.dart';

///Autor: Javier Ramos Marco
/// * Vista de las asignaturas
///

class ListadoAsignaturasVista extends StatefulWidget {
  final UsuarioAutenticado _usuario;
  const ListadoAsignaturasVista({required UsuarioAutenticado usuario, Key? key})
      : _usuario = usuario,
        super(key: key);

  @override
  State<ListadoAsignaturasVista> createState() =>
      _ListadoAsignaturasVistaState();
}

class _ListadoAsignaturasVistaState extends State<ListadoAsignaturasVista> {
  List<Asignatura> asignaturas = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<AsignaturaBloc>()
        .add(ObtenerAsignaturas(idUsuario: widget._usuario.id));

    return MultiBlocListener(
      listeners: [
        BlocListener<ListasAsistenciaBloc, EstadoListasAsistencia>(
          listener: (context, state) {
            if (state is ListasAsistenciaEliminadas) {
              context
                  .read<AsignaturaBloc>()
                  .add(ObtenerAsignaturas(idUsuario: widget._usuario.id));
            }
          },
        ),
      ],
      child: BlocConsumer<AsignaturaBloc, EstadoAsignatura>(
        listener: (context, state) {
          if (state is AsignaturaEliminadaCorrectamente) {
            context.read<ListasAsistenciaBloc>().add(
                EliminarListasAsistenciaDiayMes(
                    idAsignatura: state.idAsignatura));
          } else if (state is AsignaturaError) {
            MiSnackBar.informacionSnackBar(context, state.mensaje);
          }
        },
        builder: (context, state) {
          if (state is AsignaturasUsuarioObtenidas) {
            asignaturas = state.asignaturas;
            return Scaffold(
                appBar: MiAppBar(
                  titulo: "Asignaturas",
                  ruta: calendarioRuta,
                  argumentos: widget._usuario,
                ),
                body: asignaturas.isEmpty
                    ? const Center(child: Text(noHayAsignaturasCreadas))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListadoAsignaturas(
                              asignaturas: asignaturas,
                              usuario: widget._usuario,
                            ),
                          ],
                        )));
          }
          return const PantallaCarga();
        },
      ),
    );
  }
}
