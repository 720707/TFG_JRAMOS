import 'dart:typed_data';

import 'package:control_asistencia_tfg_jrm/datos/modelos/alumnoPDF.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/generar_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/parametros.dart';

void main() {
  late GeneradorPdf generadorPdf;
  setUp(() {
    generadorPdf = GeneradorPdf();
  });

  group('generar PDF test', () {
    test('generar pdf', () async {
      var pdf = await generadorPdf.generarPdf(
          alumnos: alumnosPDF,
          listaAsistencias: listasAsistenciasMesMock.first);
      expect(pdf, isA<Uint8List>());
    });

    test('generar alumnos pdf', () {
      var alumnosPdf = generadorPdf.generarAlumnosPdf(
          asignatura: asignaturaConListaParaPDF,
          listaAsistenciasMes: listasAsistenciasMesParaPDF.first);
      expect(alumnosPdf, isA<List<AlumnoPDF>>());
    });
  });
}
