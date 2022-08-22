import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/base_de_datos/excepciones_base_datos.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/calendario/calendario_clases_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/clase/pasar_lista_clase_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AsignaturaBloc asignaturaBloc;
  late ListasAsistenciaBloc listasAsistenciasBloc;
  late MockNavigator navigator;
  late ListaAsistenciasDia listaAsistencias;
  late Widget widgetTest;
  setUpAll(() {
    asignaturaBloc = MockAsignaturaBloc();
    listasAsistenciasBloc = MockListasAsistenciaBloc();
    navigator = MockNavigator();
    widgetTest = MultiBlocProvider(
      providers: [
        BlocProvider<AsignaturaBloc>(
          create: (context) => asignaturaBloc,
        ),
        BlocProvider<ListasAsistenciaBloc>(
          create: (context) => listasAsistenciasBloc,
        ),
      ],
      child: MaterialApp(
          home: MockNavigatorProvider(
        navigator: navigator,
        child: PasarListaEnClaseVista(
          clase: clasesConAlumnos.first,
          usuario: usuario,
        ),
      )),
    );

    String idListaAsistencia = clasesConAlumnos.first.idClase +
        clasesConAlumnos.first.diaClase.day.toString() +
        clasesConAlumnos.first.diaClase.month.toString();
    listaAsistencias = ListaAsistenciasDia(
        fecha: clasesConAlumnos.first.diaClase,
        idAsignatura: clasesConAlumnos.first.idAsignatura,
        alumnos: clasesConAlumnos.first.alumnos,
        idListaAsistenciasDia: idListaAsistencia);
  });

  group('Pasar Lista Clase Vista test', () {
    testWidgets(
      "Elementos visibles correctamente al carga la vista...",
      (tester) async {
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        when(() => listasAsistenciasBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        await tester.pumpWidget(widgetTest);

        expect(find.byType(MiAppBar), findsOneWidget);
        expect(find.byType(ListadoAlumnos), findsWidgets);
        expect(find.byType(BotonGenerico), findsOneWidget);
      },
    );

    testWidgets(
      "Volver atrás...",
      (tester) async {
        when(() =>
                navigator.popAndPushNamed(calendarioRuta, arguments: usuario))
            .thenAnswer((_) async {
          return CalendarioyClasesVista;
        });
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        when(() => listasAsistenciasBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        await tester.pumpWidget(widgetTest);

        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.arrow_back));

        await tester.pumpAndSettle();

        verify(() =>
                navigator.popAndPushNamed(calendarioRuta, arguments: usuario))
            .called(1);
      },
    );

    testWidgets(
      "Clicar alumno cambia estado (de presente a no presente)...",
      (tester) async {
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        when(() => listasAsistenciasBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        await tester.pumpWidget(widgetTest);

        expect(find.byType(MiAppBar), findsOneWidget);
        expect(find.byType(ListadoAlumnos), findsWidgets);
        expect(find.byType(BotonGenerico), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsWidgets);
        expect(find.byIcon(Icons.cancel_outlined), findsNothing);

        await tester.tap(find.byType(MiListTileIconosCambiables).first);
        await tester.pump(const Duration(seconds: 2));
        expect(find.byIcon(Icons.cancel_outlined).first, findsOneWidget);
      },
    );

    testWidgets(
      "Enviar evento al presiona pasar lista...",
      (tester) async {
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        when(() => listasAsistenciasBloc.state)
            .thenReturn(ListasAsistenciaInitial());

        await tester.pumpWidget(widgetTest);

        await tester.pump(const Duration(seconds: 2));
        await tester.tap(find.byType(BotonGenerico));

        verify(() => listasAsistenciasBloc.add(PasarListaDia(
            listaAsistenciasDia: listaAsistencias,
            clase: clasesConAlumnos.first))).called(1);
      },
    );

    testWidgets('Muestra SnackBar en caso de error', (tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        const AsignaturaError(
            excepcion: NoSePuedeAnyadirAsignaturaAAlumno(), mensaje: 'Error'),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());
      when(() => listasAsistenciasBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(widgetTest);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Muestra SnackBar para informar', (tester) async {
      final estadosEsperados = [
        ListasAsistenciaInitial(),
        ListaAsistenciasDiaPasada(listaAsistenciaDia),
      ];
      whenListen(listasAsistenciasBloc,
          Stream<EstadoListasAsistencia>.fromIterable(estadosEsperados),
          initialState: ListasAsistenciaInitial());
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());

      await tester.pumpWidget(widgetTest);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
