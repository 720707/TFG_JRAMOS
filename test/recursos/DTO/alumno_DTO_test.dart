import 'dart:convert';

import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../utils/parametros.dart';

void main() {
  test('Es una subclase de Alumno entidad', () async {
    expect(alumnoDTO, isA<Alumno>());
  });

  test('fromJson', () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('alumno.json'));

    final resultado = AlumnoDTO.fromJson(jsonMap);

    expect(resultado, alumnoDTO);
  });

  test('toJson', () async {
    final resultado = alumnoDTO.toJson();
    final json = {
      "asignaturas": ["2342342", "Matematicas"],
      "dniAlumno": "12392323N",
      "nipAlumno": "832332",
      "presente": true,
      "nombreCompleto": "Apellidos, Nombre"
    };
    expect(resultado, json);
  });

  test('fromEntity', () {
    final resultado = AlumnoDTO.fromEntity(alumnoEntidad);
    expect(resultado, alumnoDTO);
  });

  test('toEntity', () {
    final resultado = alumnoDTO.toEntity();
    expect(resultado, alumnoEntidad);
  });
}
