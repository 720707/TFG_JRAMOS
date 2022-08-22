import 'dart:convert';

import 'package:control_asistencia_tfg_jrm/datos/entidades/lista_asistencias_dia.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../utils/parametros.dart';

void main() {
  group('ListaAsistenciasDiaDTO test', () {
    test('Es una subclase de ListaAsistencia entidad', () {
      expect(listaAsistenciasDiaDTO, isA<ListaAsistenciasDia>());
    });
    test('fromJson', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('listaAsistenciasDia.json'));

      final resultado = ListaAsistenciasDiaDTO.fromJson(jsonMap);

      expect(resultado, listaAsistenciasDiaDTO);
    });

    test('toJson', () async {
      final resultado = listaAsistenciasDiaDTO.toJson();
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
        "fecha": "2022-08-15T00:00:00.000Z",
        "idAsignatura": "DB434443ddsa",
        "idListaAsistenciasDia": "DB434443ddsa43344"
      };
      expect(resultado, json);
    });

    test('fromEntity', () {
      final resultado =
          ListaAsistenciasDiaDTO.fromEntity(listaAsistenciasDiaEntidad);
      expect(resultado, listaAsistenciasDiaDTO);
    });

    test('toEntity', () {
      final resultado = listaAsistenciasDiaDTO.toEntity();
      expect(resultado, listaAsistenciasDiaEntidad);
    });
  });
}
