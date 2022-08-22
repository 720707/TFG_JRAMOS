import 'dart:convert';

import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/DTO/asignatura_DTO.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../utils/parametros.dart';

void main() {
  group('Asignatura DTO test', () {
    test('Es una sublcase de Asignatura entidad', () {
      expect(asignaturaDTO, isA<Asignatura>());
    });

    test('fromJson', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('asignatura.json'));

      final resultado = AsignaturaDTO.fromJson(jsonMap);

      expect(resultado, asignaturaDTO);
    });

    test('toJson', () async {
      final resultado = asignaturaDTO.toJson();
      final json = {
        "dias": ["lunes", "miércoles"],
        "fechaFin": "2022-10-22T00:00:00.000Z",
        "fechaInicio": "2022-08-13T00:00:00.000Z",
        "idAlumnos": ["73434", "43434"],
        "idAsignatura": "DB434443ddsa",
        "idProfesor": "332323",
        "listasAsistenciasMes": [],
        "nombreAsignatura": "DB",
        "nombreGrado": "Informática"
      };
      expect(resultado, json);
    });

    test('fromEntity', () {
      final resultado = AsignaturaDTO.fromEntity(asignaturaEntidad);
      expect(resultado, asignaturaDTO);
    });

    test('toEntity', () {
      final resultado = asignaturaDTO.toEntity();
      expect(resultado, asignaturaEntidad);
    });
  });
}
