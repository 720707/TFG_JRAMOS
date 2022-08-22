import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/rutas/generador_rutas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/botones/boton_generico.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/botones/boton_ir_a_ruta.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/campos_texto/campo_texto_formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AutenticacionBloc autenticacionBloc;
  late MockNavigator navigator;
  late GeneradorDeRutas generadorDeRutas;

  late Widget testWidget;

  setUpAll(() {
    autenticacionBloc = MockAutenticacionBloc();
    navigator = MockNavigator();
    generadorDeRutas = GeneradorDeRutas();

    when(() => autenticacionBloc.state).thenReturn(SesionIniciada(usuario));

    testWidget = BlocProvider<AutenticacionBloc>(
      create: (context) => autenticacionBloc,
      child: MaterialApp(
        onGenerateRoute: generadorDeRutas.generarRuta,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: MockNavigatorProvider(
          navigator: navigator,
          child: InicioSesionVista(),
        ),
      ),
    );
  });

  group('Inicio Sesion Vista', () {
    testWidgets('Elementos visibles corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CampoTextoFormulario), findsNWidgets(2));
      expect(find.byType(BotonIrARuta), findsNWidgets(2));
      expect(find.byType(IniciarSesionBoton), findsNWidgets(1));
      expect(find.byType(BotonGenerico), findsNWidgets(1));
      expect(find.byType(Image), findsNWidgets(1));
      expect(find.byType(FormBuilder), findsNWidgets(1));
    });

    testWidgets('Iniciar sesion mediante correo y contraseña',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(CampoTextoFormulario).first, 'ramosjavier1997@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(CampoTextoFormulario).last, 'jose0122');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IniciarSesionBoton));
      await tester.pump();
      verify(() => autenticacionBloc.add(const IniciarSesion(
          correo: 'ramosjavier1997@gmail.com',
          password: 'jose0122'))).called(1);
    });

    testWidgets('Iniciar sesion con google', (WidgetTester tester) async {
      await tester.pumpAndSettle();
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(BotonGenerico));
      await tester.pump();
      verify(() => autenticacionBloc.add(const IniciarSesionConGoogle()))
          .called(1);
    });

    testWidgets('Introducir datos', (WidgetTester tester) async {
      when(() => autenticacionBloc.state)
          .thenAnswer((invocation) => SesionIniciada(usuario));
      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('correo')), 'prueba@gmail.com');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('password')), 'password1234');
      await tester.pump();

      expect(find.byKey(const Key('correo')).evaluate().isNotEmpty, true);
      expect(find.byKey(const Key('password')).evaluate().isNotEmpty, true);
    });

    testWidgets('Pulsar "Registrate aqui" nos lleva a la ventana de Registro',
        (WidgetTester tester) async {
      when(() => navigator.pushNamed(registroRuta)).thenAnswer((_) async {
        return RegistroVista;
      });
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CampoTextoFormulario), findsNWidgets(2));
      expect(find.byType(BotonIrARuta), findsNWidgets(2));
      expect(find.byType(IniciarSesionBoton), findsNWidgets(1));
      expect(find.byType(BotonGenerico), findsNWidgets(1));
      expect(find.byType(Image), findsNWidgets(1));
      expect(find.byType(FormBuilder), findsNWidgets(1));

      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.widgetWithText(TextButton, registrarBoton));
      await tester.pumpAndSettle();

      verify(() => navigator.pushNamed(registroRuta)).called(1);
    });

    testWidgets('''Pulsar "¿Has olvidado tu contraseña?" nos lleva a la
      ventana de Nueva Contraseña''', (WidgetTester tester) async {
      when(() => navigator.pushNamed(nuevaPasswordRuta)).thenAnswer((_) async {
        return NuevaPasswordVista;
      });
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CampoTextoFormulario), findsNWidgets(2));
      expect(find.byType(BotonIrARuta), findsNWidgets(2));
      expect(find.byType(IniciarSesionBoton), findsNWidgets(1));
      expect(find.byType(BotonGenerico), findsNWidgets(1));
      expect(find.byType(Image), findsNWidgets(1));
      expect(find.byType(FormBuilder), findsNWidgets(1));

      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.widgetWithText(TextButton, cambiarPassword));
      await tester.pumpAndSettle();

      verify(() => navigator.pushNamed(nuevaPasswordRuta)).called(1);
    });
  });
}
