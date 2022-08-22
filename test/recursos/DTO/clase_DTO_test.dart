import 'dart:convert';

import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/DTO/clase_DTO.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../utils/parametros.dart';

void main() {
  group('Clase DTO test', () {
    test('Es una subclase de Clase entidad', () {
      expect(claseDTO, isA<Clase>());
    });

    test('fromJson', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('clase.json'));

      final resultado = ClaseDTO.fromJson(jsonMap);

      expect(resultado, claseDTO);
    });

    test('toJson', () async {
      final resultado = claseDTO.toJson();
      final json = {
        "alumnos": [
          {
            "asignaturas": ["2342342", "Matematicas"],
            "dniAlumno": "0",
            "nipAlumno": "0",
            "presente": true,
            "nombreCompleto": "Segundo, Tomas"
          },
          {
            "asignaturas": ["2342342", "Matematicas"],
            "dniAlumno": "1",
            "nipAlumno": "1",
            "presente": true,
            "nombreCompleto": "Segundo, Tomas"
          }
        ],
        "diaClase": "2022-08-15T00:00:00.000Z",
        "idAsignatura": "DB434443ddsa",
        "idClase": "D4433344",
        "idProfesor": "54454",
        "listaPasada": true,
        "nombreAsignatura": "DB",
        "nombreGrado": "Informática"
      };
      expect(resultado, json);
    });

    test('fromEntity', () {
      final resultado = ClaseDTO.fromEntity(claseEntidad);
      expect(resultado, claseDTO);
    });

    test('toEntity', () {
      final resultado = claseDTO.toEntity();
      expect(resultado, claseEntidad);
    });
  });
}
