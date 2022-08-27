import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../configuracion/configuracion.dart';
import '../../../datos/datos.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista previa del pdf con las listas de asistencia
///

class VistaPreviaPdf extends StatelessWidget {
  final Uint8List _pdf;
  final UsuarioAutenticado _usuario;
  final Asignatura _asignatura;
  final ListaAsistenciasMes _listaAsistencias;
  const VistaPreviaPdf(
      {required Uint8List pdf,
      required UsuarioAutenticado usuario,
      required Asignatura asignatura,
      required ListaAsistenciasMes listaAsistencias,
      Key? key})
      : _pdf = pdf,
        _usuario = usuario,
        _asignatura = asignatura,
        _listaAsistencias = listaAsistencias,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(
          ruta: listaMesesRuta,
          titulo: tituloPrevisualizacionPDF,
          argumentos:
              ArgumentosPantalla(usuario: _usuario, asignatura: _asignatura)),
      body: PdfPreview(
        build: (context) => _pdf,
        pdfFileName:
            '${_asignatura.nombreAsignatura}_${_asignatura.nombreGrado}_${_listaAsistencias.mes.toString()}_${_listaAsistencias.anyo.toString()}.pdf',
      ),
    );
  }
}
