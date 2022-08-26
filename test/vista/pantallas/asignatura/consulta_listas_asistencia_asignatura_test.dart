import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/lista_asistencias_concreta.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listas_asistencias_por_asignatura/consulta_listas_asistencia_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listas_asistencias_por_asignatura/listado_listas_asistencia.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AsignaturaBloc asignaturaBloc;
  late ListasAsistenciaBloc listasAsistenciaBloc;
  late Widget testWidget;
  late MockNavigator navigator;

  //late List<ListaAsistenciasMesEntidad> listasAsistenciasMes;

  setUpAll(() {
    asignaturaBloc = MockAsignaturaBloc();
    navigator = MockNavigator();
    listasAsistenciaBloc = MockListasAsistenciaBloc();
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
        child: ConsultaListasAsistenciaVista(
          asignatura: asignaturaConLista,
          usuario: usuario,
        ),
      )),
    );
  });

  group('Consulta listas asistencia asignatura test', () {
    testWidgets(
      "Elementos visibles correctamente al iniciar pantalla si no hay listas de asistencia",
      (WidgetTester tester) async {
        when(() => listasAsistenciaBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        await tester.pumpAndSettle();
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<AsignaturaBloc>(
              create: (context) => asignaturaBloc,
            ),
            BlocProvider<ListasAsistenciaBloc>(
              create: (context) => listasAsistenciaBloc,
            ),
          ],
          child: MaterialApp(
              home: ConsultaListasAsistenciaVista(
            asignatura: asignaturaSinLista,
            usuario: usuario,
          )),
        ));
        await tester.pumpAndSettle();

        expect(find.byType(MiAppBar), findsNWidgets(1));
        expect(find.text(textoNoHayListas), findsOneWidget);
      },
    );

    testWidgets(
      "Elementos visibles correctamente al iniciar pantalla si hay listas de asistencia",
      (WidgetTester tester) async {
        when(() => listasAsistenciaBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        await tester.pumpAndSettle();
        await tester.pumpWidget(testWidget);
        await tester.pump();

        expect(find.byType(MiAppBar), findsNWidgets(1));
        expect(find.byType(ListadoListasAsistencia), findsWidgets);
      },
    );

    testWidgets(
      "Despliega listas de asistencias al pulsar en un mes",
      (WidgetTester tester) async {
        when(() => listasAsistenciaBloc.state)
            .thenReturn(ListasAsistenciaInitial());
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());

        await tester.pumpWidget(testWidget);

        expect(find.byType(MiAppBar), findsNWidgets(1));
        expect(find.byType(ListadoListasAsistencia), findsWidgets);
        //El Slidable de cada lista de asistencia no es visible por defecto
        expect(find.byType(Slidable), findsNothing);
        await tester.tap(find
            .byKey(Key(asignaturaConLista
                .listasAsistenciasMes.first.idListaAsistenciasMes))
            .first);

        await tester.pump(const Duration(milliseconds: 100));
        //Despúes de pulsar el widget ListadoListasAsistencia,
        //los Slidable son visibles
        expect(
            find.byKey(Key(asignaturaConLista.listasAsistenciasMes.first
                .listaAsistenciasDia.first.idListaAsistenciasDia)),
            findsWidgets);
      },
    );

    testWidgets('Muestra SnackBar en caso de error', (tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        const AsignaturaError(
            excepcion: NoSePuedeAnyadirAsignaturaAlumno(), mensaje: 'Error'),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Mostrar icono editar', (tester) async {
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());

      await tester.pumpWidget(testWidget);

      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.byType(ListadoListasAsistencia), findsWidgets);
      //El Slidable de cada lista de asistencia no es visible por defecto
      expect(find.byType(Slidable), findsNothing);
      expect(find.byIcon(Icons.edit), findsNothing);
      await tester.tap(find
          .byKey(Key(asignaturaConLista
              .listasAsistenciasMes.first.idListaAsistenciasMes))
          .first);

      await tester.pump(const Duration(milliseconds: 100));
      //Despúes de pulsar el widget ListadoListasAsistencia,
      //los Slidable son visibles
      expect(
          find.byKey(Key(asignaturaConLista.listasAsistenciasMes.first
              .listaAsistenciasDia.first.idListaAsistenciasDia)),
          findsWidgets);

      await tester.dragUntilVisible(
          find.byIcon(Icons.edit),
          find
              .byKey(Key(asignaturaConLista.listasAsistenciasMes.first
                  .listaAsistenciasDia.first.idListaAsistenciasDia))
              .first,
          const Offset(-100.0, 0));
      await tester.pump();
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Clicar icono editar lista manda evento', (tester) async {
      when(() => navigator.pushNamed(listaAsistenciasConcretaRuta,
          arguments: any(named: 'arguments'))).thenAnswer((_) async {
        return ListaAsistenciaConcretaVista;
      });
      when(() => listasAsistenciaBloc.state)
          .thenReturn(ListasAsistenciaInitial());
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());

      await tester.pumpWidget(testWidget);
      await tester.tap(find
          .byKey(Key(asignaturaConLista
              .listasAsistenciasMes.first.idListaAsistenciasMes))
          .first);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.dragUntilVisible(
          find.byIcon(Icons.edit),
          find
              .byKey(Key(asignaturaConLista.listasAsistenciasMes.first
                  .listaAsistenciasDia.first.idListaAsistenciasDia))
              .first,
          const Offset(-200.0, 0));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.edit));

      verify(() => navigator.pushNamed(listaAsistenciasConcretaRuta,
          arguments: any(named: 'arguments'))).called(1);
    });
  });
}
