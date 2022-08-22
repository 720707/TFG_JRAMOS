import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/autenticacion/excepciones_autenticacion.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/usuario_autenticado.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';

void main() {
  late AutenticacionBloc autenticacionBloc;
  late Widget testWidget;
  late UsuarioAutenticado usuario;
  late MockNavigator navigator;

  setUpAll(() {
    autenticacionBloc = MockAutenticacionBloc();

    navigator = MockNavigator();
    usuario = const UsuarioAutenticado(
        id: '2122', email: 'prueba@gmail.com', emailVerificado: true);

    testWidget = BlocProvider.value(
      value: autenticacionBloc,
      child: const MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
            home: ComprobacionAutenticacionVista(),
          )),
    );
  });

  group('Comprobacion Autenticacion Vista', () {
    testWidgets('Elementos Visibles Correctamente',
        (WidgetTester tester) async {
      when(() => autenticacionBloc.state).thenReturn(const NoAutenticado());
      await tester.pump();
      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.byType(PantallaCarga), findsNWidgets(1));
    });

    testWidgets('Va a calendario cuando el usuario ha iniciado sesion',
        (WidgetTester tester) async {
      when(() => navigator.pushNamed(calendarioRuta, arguments: usuario))
          .thenAnswer((_) async {
        return CalendarioyClasesVista;
      });

      final estadosEsperados = [
        const EstadoCargando(),
        SesionIniciada(usuario),
      ];
      whenListen(autenticacionBloc,
          Stream<EstadoAutenticacion>.fromIterable(estadosEsperados),
          initialState: const EstadoCargando());

      await tester.pumpWidget(BlocProvider<AutenticacionBloc>(
        create: (context) => autenticacionBloc,
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const ComprobacionAutenticacionVista(),
          ),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PantallaCarga), findsNWidgets(1));
      verify(() => navigator.pushNamed(calendarioRuta, arguments: usuario))
          .called(1);
    });

    testWidgets(
        'Va a la vista Introduccion cuando el usuario no ha iniciado sesion',
        (WidgetTester tester) async {
      when(() => navigator.pushNamed(introduccionRuta)).thenAnswer((_) async {
        return IntroduccionVista;
      });
      final estadosEsperados = [
        const EstadoCargando(),
        const NoAutenticado(),
      ];
      whenListen(autenticacionBloc,
          Stream<EstadoAutenticacion>.fromIterable(estadosEsperados),
          initialState: const EstadoCargando());

      await tester.pumpWidget(BlocProvider<AutenticacionBloc>(
        create: (context) => autenticacionBloc,
        child: MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator,
              child: const Scaffold(body: ComprobacionAutenticacionVista())),
        ),
      ));

      await tester.pump();
      verify(() => navigator.pushNamed(introduccionRuta)).called(1);
    });

    testWidgets(
        'Va a la vista Verificar Correo cuando el usuario no ha verificado su correo',
        (WidgetTester tester) async {
      when(() => navigator.pushNamed(verificarCorreoRuta))
          .thenAnswer((_) async {
        return IniciarSesion;
      });
      final estadosEsperados = [
        const EstadoCargando(),
        const SinVerificarCorreo(),
      ];
      whenListen(autenticacionBloc,
          Stream<EstadoAutenticacion>.fromIterable(estadosEsperados),
          initialState: const EstadoCargando());

      await tester.pumpWidget(BlocProvider<AutenticacionBloc>(
        create: (context) => autenticacionBloc,
        child: MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator,
              child: const Scaffold(body: ComprobacionAutenticacionVista())),
        ),
      ));

      await tester.pump();
      verify(() => navigator.pushNamed(verificarCorreoRuta)).called(1);
    });

    testWidgets('Muestra snackBar cuando se produce un error',
        (WidgetTester tester) async {
      final estadosEsperados = [
        const EstadoCargando(),
        const ErrorAutenticacion(
            excepcion: ExcepcionGenerica(), mensaje: 'Error'),
      ];
      whenListen(autenticacionBloc,
          Stream<EstadoAutenticacion>.fromIterable(estadosEsperados),
          initialState: const EstadoCargando());

      await tester.pumpWidget(BlocProvider<AutenticacionBloc>(
        create: (context) => autenticacionBloc,
        child: MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator,
              child: const Scaffold(body: ComprobacionAutenticacionVista())),
        ),
      ));

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
