import 'dart:typed_data';

import 'package:control_asistencia_tfg_jrm/configuracion/constantes/rutas.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/consulta_listas_meses_para_pdf.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pdf/vista_previa_pdf.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:printing/printing.dart';

import '../../../utils/parametros.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late Uint8List pdf;
  late MockNavigator navigator;
  late Widget testWidget;

  setUpAll(() {
    List<int> list = 'xxx'.codeUnits;
    pdf = Uint8List.fromList(list);
    navigator = MockNavigator();
    testWidget = MaterialApp(
        home: MockNavigatorProvider(
      navigator: navigator,
      child: VistaPreviaPdf(
        asignatura: asignaturaConListaParaPDF,
        listaAsistencias: listasAsistenciasMesMock.first,
        pdf: pdf,
        usuario: usuario,
      ),
    ));
  });

  group('Visor PDF test', () {
    testWidgets('Elementos visibles correctamente al cargar la vista ...',
        (tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(MiAppBar), findsOneWidget);
      expect(find.byType(PdfPreview), findsOneWidget);
    });

    testWidgets('Volver a la pantalla previa al pulsar la flecha superior ...',
        (tester) async {
      when(() => navigator.popAndPushNamed(listaMesesRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return ConsultaListasMesesParaPdfVista;
      });
      await tester.pumpWidget(testWidget);

      tester.getCenter(find.byIcon(Icons.arrow_back));

      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump(const Duration(seconds: 2));
      verify(() => navigator.popAndPushNamed(listaMesesRuta,
          arguments: any(named: 'arguments'))).called(1);
    });
  });
}
