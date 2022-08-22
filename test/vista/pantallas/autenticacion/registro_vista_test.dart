import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/campos_texto/campo_texto_formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AutenticacionBloc autenticacionBloc;
  late Widget testWidget;
  late MockNavigator navigator;

  setUpAll(() {
    autenticacionBloc = MockAutenticacionBloc();
    navigator = MockNavigator();

    when(() => autenticacionBloc.state).thenReturn(const NoAutenticado());

    testWidget = BlocProvider<AutenticacionBloc>(
      create: (context) => autenticacionBloc,
      child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es')
          ],
          home: MockNavigatorProvider(
              navigator: navigator, child: RegistroVista())),
    );
  });

  group('Registro Vista', () {
    testWidgets('Elementos Visibles Correctamente en Registro',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CampoTextoFormulario), findsNWidgets(3));
      expect(find.byType(RegistroBoton), findsNWidgets(1));
    });

    testWidgets('Introducir datos', (WidgetTester tester) async {
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => SesionIniciada(usuario));
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('correo')), 'prueba@gmail.com');
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('password')), 'prueba@gmail.com');
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('password_confirmar')), 'prueba@gmail.com');
      await tester.pump();

      expect(find.byKey(const Key('correo')).evaluate().isNotEmpty, true);
      expect(find.byKey(const Key('password')).evaluate().isNotEmpty, true);
      expect(find.byKey(const Key('password_confirmar')).evaluate().isNotEmpty,
          true);
    });

    testWidgets('Vuelver a atrás al pulsar el botón ',
        (WidgetTester tester) async {
      when(() => navigator.popAndPushNamed(iniciarSesionRuta))
          .thenAnswer((_) async {
        return InicioSesionVista;
      });
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => SesionIniciada(usuario));
      await tester.pumpWidget(MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator, child: RegistroVista())));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pumpAndSettle();

      verify(() => navigator.popAndPushNamed(iniciarSesionRuta)).called(1);
    });

    //Me interesa hacerlo
    testWidgets('Registrar usuario manda evento', (WidgetTester tester) async {
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => const NoAutenticado());

      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('correo')), 'prueba@gmail.com');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(find.byKey(const Key('password')), '1234567890');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(
          find.byKey(const Key('password_confirmar')), '1234567890');
      await tester.pump(const Duration(milliseconds: 300));

      await tester.pump();
      await tester.tap(find.byType(RegistroBoton));

      verify(
        () => autenticacionBloc.add(const RegistrarUsuario(
            correo: 'prueba@gmail.com', password: '1234567890')),
      ).called(1);
    });
  });
}
