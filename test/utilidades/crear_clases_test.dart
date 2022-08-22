import 'package:control_asistencia_tfg_jrm/datos/entidades/entidades.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/crear_clases.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/parametros.dart';

void main() {
  late GeneradorClases generadorClases;
  setUp(() {
    generadorClases = GeneradorClases();
  });

  test('generar clases', () {
    var clases = generadorClases.crearClases(
        asignatura: asignaturaConLista, alumnos: alumnos);

    expect(clases, isA<List<Clase>>());
  });
}
