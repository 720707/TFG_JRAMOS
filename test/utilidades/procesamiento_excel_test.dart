import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/procesamiento_excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/parametros.dart';

class MockProcesadorExcel extends Mock implements ProcesadorExcel {}

void main() {
  late MockProcesadorExcel mockProcesadorExcel;
  setUp(() {
    mockProcesadorExcel = MockProcesadorExcel();
  });
  group('Procesamiento excel test', () {
    test('test name', () async {
      when(() => mockProcesadorExcel.procesar())
          .thenAnswer((invocation) async => alumnosListaCorta);
      var alumnos = await mockProcesadorExcel.procesar();
      expect(alumnos, isA<List<Alumno>>());
    });
  });
}
