import 'dart:convert';

import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../utils/parametros.dart';

void main() {
  group('ListaAsistenciasMes test', () {
    test('ListaAsistenciasMesDTO es un subtipo de ListaAsistenciasMes', () {
      expect(listaAsistenciasMesDTO, isA<ListaAsistenciasMes>());
    });

    test('fromJson', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('listaAsistenciasMes.json'));

      final resultado = ListaAsistenciasMesDTO.fromJson(jsonMap);

      expect(resultado, listaAsistenciasMesDTO);
    });

    test('toJson', () async {
      final resultado = listaAsistenciasMesDTO.toJson();
      final json = {
        "anyo": 2022,
        "idAsignatura": "DB434443ddsa",
        "idListaAsistenciasMes": "DB434443ddsa4334443dsd",
        "listaAsistenciasDia": [
          {
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
            "idListaAsistenciasDia": "0"
          },
          {
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
            "fecha": "2022-08-16T00:00:00.000Z",
            "idAsignatura": "DB434443ddsa",
            "idListaAsistenciasDia": "1"
          }
        ],
        "mes": 8
      };
      expect(resultado, json);
    });

    test('toEntity', () {
      final resultado = listaAsistenciasMesDTO.toEntity();
      expect(resultado, listaAsistenciasMesEntidad);
    });
  });
}
