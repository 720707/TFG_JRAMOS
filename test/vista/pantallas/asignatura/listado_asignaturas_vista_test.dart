import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_asignaturas/listado_asignaturas_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_asignaturas/listado_asignaturas_widget.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_asignaturas/widget_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_opciones_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/calendario/calendario_clases_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/dialogos/pantalla_carga.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AsignaturaBloc asignaturaBloc;
  late ListasAsistenciaBloc listasAsistenciaBloc;
  late MockNavigator navigator;
  late Widget testWidget;
  setUpAll(() {
    asignaturaBloc = MockAsignaturaBloc();
    listasAsistenciaBloc = MockListasAsistenciaBloc();
    navigator = MockNavigator();
    testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AsignaturaBloc>(
          create: (context) => asignaturaBloc,
        ),
        BlocProvider<ListasAsistenciaBloc>(
          create: (context) => listasAsistenciaBloc,
        ),
      ],
      child: MaterialApp(
        home: MockNavigatorProvider(
          navigator: navigator,
          child: ListadoAsignaturasVista(
            usuario: usuario,
          ),
        ),
      ),
    );
  });
  group('Listado asignaturas vista', () {
    testWidgets('Muestra asignaturas si hay asignaturas ...', (tester) async {
      when(() => asignaturaBloc.state)
          .thenReturn(AsignaturasUsuarioObtenidas(asignaturas: asignaturas));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);

      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.byType(ListadoAsignaturas), findsWidgets);
    });

    testWidgets('Mostrar icono eliminar asignatura', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      // await tester.pumpAndSettle();
      await tester.pumpWidget(testWidget);
      //await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byIcon(Icons.delete_forever_rounded), findsNothing);
      expect(find.byType(WidgetAsignatura), findsNothing);

      await tester.tap(find.text("2022"));
      await tester.pumpAndSettle();
      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));
      expect(find.byType(WidgetAsignatura).first, findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.delete_forever_rounded),
          find.byType(WidgetAsignatura).first, const Offset(-50.0, 0.0));
      //await tester.tap(find.byType(WidgetAsignatura).first);
      expect(find.byIcon(Icons.delete_forever_rounded), findsOneWidget);
    });

    testWidgets('Clicar boton de eliminar asignatura manda evento',
        (tester) async {
      when(() => navigator.pushNamed(opcionesAsignaturasRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return OpcionesAsignaturaVista;
      });
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(testWidget);

      expect(find.byIcon(Icons.delete_forever_rounded), findsNothing);
      expect(find.byType(WidgetAsignatura), findsNothing);

      await tester.tap(find.text("2022"));
      await tester.pumpAndSettle();
      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));
      expect(find.byType(WidgetAsignatura).first, findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.delete_forever_rounded),
          find.byType(WidgetAsignatura).first, const Offset(-300.0, 0.0));

      await tester.tap(find.byIcon(Icons.delete_forever_rounded).first);
      verify(() => asignaturaBloc.add(EliminarAsignatura(
          idAsignatura: asignaturasMismoAnyo.first.idAsignatura,
          idUsuario: usuario.id))).called(1);
    });

    testWidgets(
        'Clicar en una asignatura navega a la pagina de opciones de la asignatura',
        (tester) async {
      when(() => navigator.pushNamed(opcionesAsignaturasRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return OpcionesAsignaturaVista;
      });
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(testWidget);
      //await tester.pump(const Duration(milliseconds: 1000));
      expect(find.byIcon(Icons.delete_forever_rounded), findsNothing);
      expect(find.byType(WidgetAsignatura), findsNothing);

      await tester.tap(find.text("2022"));
      await tester.pumpAndSettle();
      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));

      expect(find.byType(WidgetAsignatura), findsNWidgets(6));
      expect(find.byType(WidgetAsignatura).first, findsOneWidget);

      await tester.tap(find.byType(WidgetAsignatura).first);
      verify(() => navigator.pushNamed(opcionesAsignaturasRuta,
          arguments: any(named: 'arguments'))).called(1);
    });

    testWidgets('Desplegar asignaturas al pulsar en el año ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);

      await tester.pump();
      expect(find.byType(WidgetAsignatura), findsNothing);
      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.text("2022"), findsOneWidget);
      await tester.tap(find.text("2022"));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WidgetAsignatura), findsWidgets);
    });

    testWidgets('Vuelver a atrás al pulsar la flecha ',
        (WidgetTester tester) async {
      when(() => navigator.popAndPushNamed(calendarioRuta, arguments: usuario))
          .thenAnswer((_) async {
        return CalendarioyClasesVista;
      });
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pumpAndSettle();

      verify(() =>
              navigator.popAndPushNamed(calendarioRuta, arguments: usuario))
          .called(1);
    });

    testWidgets(
        'muestra PantallaCarga si no se han obtenido las asignaturas ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);
      expect(find.byType(PantallaCarga), findsNWidgets(1));
    });

    testWidgets('muestra Text si las asignaturas estan vacias ...',
        (tester) async {
      when(() => asignaturaBloc.state)
          .thenReturn(const AsignaturasUsuarioObtenidas(asignaturas: []));
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);

      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.text(noHayAsignaturasCreadas), findsNWidgets(1));
    });

    testWidgets('Muestra SnackBar en caso de error', (tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        const AsignaturaError(
            excepcion: NoSePuedeEliminarAsignatura(), mensaje: 'Error'),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
