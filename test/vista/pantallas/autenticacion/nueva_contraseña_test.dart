import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
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
                navigator: navigator, child: NuevaPasswordVista())));
  });

  group('Registro Vista', () {
    testWidgets('Elementos Visibles Correctamente',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.byType(CampoTextoFormulario), findsNWidgets(1));
      expect(find.byType(NuevaPasswordBoton), findsNWidgets(1));
    });

    testWidgets('Introducir datos', (WidgetTester tester) async {
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => SesionIniciada(usuario));
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('correo')), 'prueba@gmail.com');
      await tester.pump();

      expect(find.byKey(const Key('correo')).evaluate().isNotEmpty, true);
    });

    testWidgets('Vuelver a atrás al pulsar el botón ',
        (WidgetTester tester) async {
      when(() => navigator.popAndPushNamed(iniciarSesionRuta))
          .thenAnswer((_) async {
        return InicioSesionVista;
      });
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => SesionIniciada(usuario));
      await tester.pumpWidget(testWidget);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pumpAndSettle();

      verify(() => navigator.popAndPushNamed(iniciarSesionRuta)).called(1);
    });

    testWidgets('Enviar evento al pulsar el boton ...', (tester) async {
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('correo')), 'prueba@gmail.com');

      await tester.pump();
      await tester.tap(find.byType(NuevaPasswordBoton));
      await tester.pump();

      verify(() => autenticacionBloc
          .add(const NuevaPassword(correo: 'prueba@gmail.com'))).called(1);
    });
  });
}
