import '../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../datos/datos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../configuracion/configuracion.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista de los meses para crear PDF en una asignatura
///

class ConsultaListasMesesParaPdfVista extends StatefulWidget {
  final Asignatura _asignatura;
  final UsuarioAutenticado _usuario;
  const ConsultaListasMesesParaPdfVista(
      {required Asignatura asignatura,
      required UsuarioAutenticado usuario,
      Key? key})
      : _asignatura = asignatura,
        _usuario = usuario,
        super(key: key);

  @override
  State<ConsultaListasMesesParaPdfVista> createState() =>
      _ConsultaListasMesesParaPdfVistaState();
}

void Function()? generarPdf(BuildContext context,
    {required Asignatura asignatura,
    required ListaAsistenciasMes listaAsistenciasMes}) {
  context.read<AsignaturaBloc>().add(GenerarPDF(
        asignatura: asignatura,
        listaAsistenciasMes: listaAsistenciasMes,
      ));
  return null;
}

class _ConsultaListasMesesParaPdfVistaState
    extends State<ConsultaListasMesesParaPdfVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(
        titulo: "PDF - ${widget._asignatura.nombreAsignatura}",
        ruta: opcionesAsignaturasRuta,
        argumentos: ArgumentosPantalla(
            asignatura: widget._asignatura, usuario: widget._usuario),
      ),
      body: BlocListener<AsignaturaBloc, EstadoAsignatura>(
        listener: (context, state) {
          if (state is PdfGenerado) {
            Navigator.of(context).pushNamed(visorPDFRuta,
                arguments: ArgumentosPantalla(
                    usuario: widget._usuario,
                    pdf: state.pdf,
                    asignatura: widget._asignatura,
                    listaAsistenciasMes: state.listaAsistenciaMes));
          } else if (state is AsignaturaError) {
            MiSnackBar.informacionSnackBar(context, state.mensaje);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: widget._asignatura.listasAsistenciasMes.isEmpty
                        ? const Center(
                            child: Text(textoNoHayPDFs),
                          )
                        : ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: widget._asignatura.listasAsistenciasMes
                                .map((listaAsistenciasMes) {
                              String mes = DateFormat.MMMM().format(
                                  listaAsistenciasMes
                                      .listaAsistenciasDia.first.fecha);
                              return Card(
                                  child: MiListTile(
                                      titulo:
                                          '${mes.toString().toUpperCase()} - ${listaAsistenciasMes.anyo}',
                                      onTap: () {
                                        generarPdf(context,
                                            asignatura: widget._asignatura,
                                            listaAsistenciasMes:
                                                listaAsistenciasMes);
                                      }));
                            }).toList(),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
