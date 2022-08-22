import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:mockingjay/mockingjay.dart';

void main() {
  late MockNavigator navigator;
  setUpAll(() {
    navigator = MockNavigator();
  });
  group('Introduccion vista test', () {
    testWidgets('Elementos visibles correctamente al cargar el primer slide...',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroduccionVista()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(IntroSlider), findsOneWidget);
      expect(find.byIcon(Icons.skip_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.text("AÑADE ASIGNATURAS"), findsOneWidget);
    });

    testWidgets('Pasar al siguiente slider ...', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IntroduccionVista()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(IntroSlider), findsOneWidget);
      expect(find.byIcon(Icons.skip_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.text("AÑADE ASIGNATURAS"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.navigate_next));
      await tester.pumpAndSettle();
      expect(find.text("CARGAR ALUMNOS"), findsOneWidget);
    });

    testWidgets('Manda evento cuando pulsamos el boton de finalizar ...',
        (tester) async {
      when(() => navigator.pushNamed(iniciarSesionRuta)).thenAnswer((_) async {
        return ComprobacionAutenticacionVista;
      });
      await tester.pumpWidget(MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator, child: const IntroduccionVista())));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.skip_next));

      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.done));
      await tester.pump(const Duration(milliseconds: 300));
      verify(() => navigator.pushNamed(iniciarSesionRuta)).called(1);
    });
  });
}
