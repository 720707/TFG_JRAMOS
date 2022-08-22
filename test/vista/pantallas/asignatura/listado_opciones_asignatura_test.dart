import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_asignaturas/listado_asignaturas_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_opciones_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listas_asistencias_por_asignatura/consulta_listas_asistencia_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/botones/elevated_boton_ir_a_ruta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../utils/parametros.dart';

void main() {
  late Widget widgetTester;
  late MockNavigator navigator;
  setUpAll(() {
    navigator = MockNavigator();
    widgetTester = MaterialApp(
        home: MockNavigatorProvider(
      navigator: navigator,
      child: OpcionesAsignaturaVista(
        asignatura: asignaturas.first,
        usuario: usuario,
      ),
    ));
  });
  group('Listado opciones asignatura vista test', () {
    testWidgets('Se muestran los elementos correctamente ...', (tester) async {
      await tester.pumpWidget(widgetTester);

      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.byType(ElevatedBotonIrARuta), findsNWidgets(2));
    });

    testWidgets('Vuelver atrás al pulsar la flecha ', (tester) async {
      when(() => navigator.popAndPushNamed(listarAsignaturasRuta,
          arguments: usuario)).thenAnswer((_) async {
        return ListadoAsignaturasVista;
      });

      await tester.pumpWidget(widgetTester);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pumpAndSettle();

      verify(() => navigator.popAndPushNamed(listarAsignaturasRuta,
          arguments: usuario)).called(1);
    });

    testWidgets('Pulsar Consultar Listas Asistencia manda evento ',
        (tester) async {
      when(() => navigator.pushNamed(
            listasAsistenciasAsignaturaRuta,
            arguments: any(named: 'arguments'),
          )).thenAnswer((_) async {
        return ConsultaListasAsistenciaVista;
      });

      await tester.pumpWidget(widgetTester);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Consultar Listas Asistencia'));

      await tester.pump(const Duration(milliseconds: 500));

      verify(() => navigator.pushNamed(listasAsistenciasAsignaturaRuta,
          arguments: any(named: 'arguments'))).called(1);
    });

    testWidgets('Pulsar "Generar PDF" Asistencia manda evento ',
        (tester) async {
      when(() => navigator.pushNamed(
            listaMesesRuta,
            arguments: any(named: 'arguments'),
          )).thenAnswer((_) async {
        return ConsultaListasAsistenciaVista;
      });

      await tester.pumpWidget(widgetTester);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Generar PDF'));

      await tester.pump(const Duration(milliseconds: 500));

      verify(() => navigator.pushNamed(listaMesesRuta,
          arguments: any(named: 'arguments'))).called(1);
    });
  });
}
