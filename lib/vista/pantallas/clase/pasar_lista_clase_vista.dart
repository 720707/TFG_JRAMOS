import '../../../control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configuracion/configuracion.dart';
import '../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../datos/datos.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista para pasar liste en una clase
///

class PasarListaEnClaseVista extends StatefulWidget {
  final Clase _clase;
  final UsuarioAutenticado _usuario;
  const PasarListaEnClaseVista(
      {required UsuarioAutenticado usuario, required Clase clase, Key? key})
      : _clase = clase,
        _usuario = usuario,
        super(key: key);

  @override
  State<PasarListaEnClaseVista> createState() => _PasarListaEnClaseVistaState();
}

class _PasarListaEnClaseVistaState extends State<PasarListaEnClaseVista> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final altura =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final espacio = altura > 650 ? espacioM : espacioS;

    String fechaClase =
        "${widget._clase.diaClase.day}/${widget._clase.diaClase.month}";

    void enAlumnoSeleccionado(Alumno alumno) {
      setState(() {
        if (!alumno.presente) {
          alumno.presente = true;
        } else {
          alumno.presente = false;
        }
      });
    }

    ListaAsistenciasDia crearListaAsistenciaDia() {
      String idListaAsistencia = widget._clase.idClase +
          widget._clase.diaClase.day.toString() +
          widget._clase.diaClase.month.toString();
      ListaAsistenciasDia listaAsistencias = ListaAsistenciasDia(
          fecha: widget._clase.diaClase,
          idAsignatura: widget._clase.idAsignatura,
          alumnos: widget._clase.alumnos,
          idListaAsistenciasDia: idListaAsistencia);
      return listaAsistencias;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AsignaturaBloc, EstadoAsignatura>(
          listener: (context, state) {
            if (state is AsignaturaError) {
              MiSnackBar.informacionSnackBar(context, state.mensaje);
            }
            if (state is ListasActualizadas) {
              Navigator.of(context)
                  .popAndPushNamed(calendarioRuta, arguments: widget._usuario);
            }
          },
        ),
        BlocListener<ListasAsistenciaBloc, EstadoListasAsistencia>(
          listener: (context, state) {
            if (state is ListaAsistenciasDiaPasada) {
              MiSnackBar.informacionSnackBar(
                  context, textoListaAsistenciaDiaCreada);
              context.read<AsignaturaBloc>().add(
                    ActualizarListasAsistenciaDia(
                        listaAsistenciasDia: state.listaAsistenciaDia),
                  );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: MiAppBar(
          titulo: "${widget._clase.nombreAsignatura} $fechaClase",
          ruta: calendarioRuta,
          argumentos: widget._usuario,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    ListadoAlumnos(
                      widget: widget,
                      enAlumnoSeleccionado: enAlumnoSeleccionado,
                      clase: widget._clase,
                    ),
                    SizedBox(height: espacio),
                    BotonGenerico(
                        onPressed: () {
                          ListaAsistenciasDia listaAsistenciasDia =
                              crearListaAsistenciaDia();
                          context.read<ListasAsistenciaBloc>().add(
                              PasarListaDia(
                                  listaAsistenciasDia: listaAsistenciasDia,
                                  clase: widget._clase));
                        },
                        texto: 'Pasar Lista'),
                  ],
                ))),
      ),
    );
  }
}
