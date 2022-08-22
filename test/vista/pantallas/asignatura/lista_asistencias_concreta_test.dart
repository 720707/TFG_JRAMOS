import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late ListasAsistenciaBloc listaAsistenciasBloc;
  late AsignaturaBloc asignaturaBloc;
  late Widget testWidget;
  late Widget testWidgetEditable;
  late MockNavigator navigator;
  setUpAll(() {
    listaAsistenciasBloc = MockListasAsistenciaBloc();
    asignaturaBloc = MockAsignaturaBloc();
    navigator = MockNavigator();
    testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<ListasAsistenciaBloc>(
          create: (context) => listaAsistenciasBloc,
        ),
        BlocProvider<AsignaturaBloc>(
          create: (context) => asignaturaBloc,
        ),
      ],
      child: MaterialApp(
          home: ListaAsistenciaConcretaVista(
        asignatura: asignaturas.first,
        listaAsistencias: listaAsistenciaDia,
        usuario: usuario,
      )),
    );
    testWidgetEditable = MultiBlocProvider(
      providers: [
        BlocProvider<ListasAsistenciaBloc>(
          create: (context) => listaAsistenciasBloc,
        ),
        BlocProvider<AsignaturaBloc>(
          create: (context) => asignaturaBloc,
        ),
      ],
      child: MaterialApp(
          home: MockNavigatorProvider(
        navigator: navigator,
        child: ListaAsistenciaConcretaVista(
          asignatura: asignaturas.first,
          listaAsistencias: listaAsistenciaDia,
          usuario: usuario,
          editable: true,
        ),
      )),
    );
  });

  group('Lista asistencias concreta test', () {
    testWidgets(
        'Elementos visibles correctamente cuando se consulta la lista de asistencia ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);

      expect(find.byType(MiAppBar), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text("Aceptar"), findsNothing);
    });

    testWidgets('Elementos visibles correctamente cuando se edita la lista ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidgetEditable);

      expect(find.byType(MiAppBar), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text("Aceptar"), findsOneWidget);
    });

    testWidgets('Presionar "Aceptar" en el modo editable manada un evento ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidgetEditable);

      await tester.pumpAndSettle();
      await tester.tap(find.text("Aceptar"));

      verify(() => listaAsistenciasBloc.add(
          EditarListaDia(listaAsistenciasDia: listaAsistenciaDia))).called(1);
    });

    testWidgets('Lista editable cuando se esta en el modo editar ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidgetEditable);
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();
      //Todos los alumnos estan presentes (icono verde) y al presionar pasa a rojo
      expect(find.byIcon(Icons.cancel_outlined).first, findsWidgets);
    });

    testWidgets('Hacer scroll si la lista es larga ...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidget);

      await tester.pump();
      await tester.dragUntilVisible(find.byKey(const Key("16")),
          find.byType(ListView), const Offset(0, -300));
      await tester.pump();
      expect(find.byKey(const Key("16")), findsOneWidget);
      expect(find.byKey(const Key("1")), findsNothing);
    });

    testWidgets('Cuando la lista se edita correctamente se manda un evento ...',
        (tester) async {
      when(() => navigator.popAndPushNamed(listasAsistenciasAsignaturaRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return ConsultaListasAsistenciaVista;
      });

      final estadosEsperados = [
        AsignaturaInitial(),
        const ListaAsistenciasEditadaEnAsignatura(),
      ];

      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());

      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(testWidgetEditable);

      await tester.pumpAndSettle();

      verify(() => navigator.popAndPushNamed(listasAsistenciasAsignaturaRuta,
          arguments: any(named: 'arguments'))).called(1);
    });

    testWidgets('Vuelver a atrás al pulsar la flecha ',
        (WidgetTester tester) async {
      when(() => navigator.popAndPushNamed(listasAsistenciasAsignaturaRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return ConsultaListasAsistenciaVista;
      });
      when(() => asignaturaBloc.state).thenReturn(
          AsignaturasUsuarioObtenidas(asignaturas: asignaturasMismoAnyo));
      when(() => listaAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      await tester.pumpWidget(testWidgetEditable);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pumpAndSettle();

      verify(() => navigator.popAndPushNamed(listasAsistenciasAsignaturaRuta,
          arguments: any(named: 'arguments'))).called(1);
    });
  });
}
