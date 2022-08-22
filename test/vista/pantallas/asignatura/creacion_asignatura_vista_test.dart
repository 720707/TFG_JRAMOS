import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/botones/boton_generico.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/campos_texto/campo_texto_formulario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:intl/intl.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AsignaturaBloc asignaturaBloc;
  late MockNavigator navigator;
  late Widget testWidget;
  setUpAll(() {
    asignaturaBloc = MockAsignaturaBloc();
    navigator = MockNavigator();
    testWidget = BlocProvider<AsignaturaBloc>(
      create: (context) => asignaturaBloc,
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
            navigator: navigator,
            child: CreacionAsignaturaVista(
              usuario: usuario,
            ),
          )),
    );
  });

  group('Creacion asignatura vista test', () {
    testWidgets('Elementos visibles correctamente al cargar la vista ...',
        (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(MiAppBar), findsOneWidget);
      expect(find.byType(CampoTextoFormulario), findsNWidgets(2));
      expect(find.byType(FechaInicio), findsOneWidget);
      expect(find.byType(FechaFin), findsOneWidget);
      expect(
          find.text('Selecciona los dias en los que se imparte la asignatura'),
          findsOneWidget);

      expect(find.byType(FormBuilderCheckboxGroup<String>), findsOneWidget);
      expect(find.byType(BotonGenerico), findsOneWidget);
      expect(find.byType(BotonCrearAsignatura), findsOneWidget);
    });

    testWidgets('Se puede escribir en los elementos ...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(CampoTextoFormulario, textoNombreAsignatura),
          'Bases de Datos');
      await tester.enterText(
          find.widgetWithText(CampoTextoFormulario, textoGradoAsignatura),
          'Informática');

      expect(
          find
              .widgetWithText(CampoTextoFormulario, textoNombreAsignatura)
              .evaluate()
              .isNotEmpty,
          true);
      expect(
          find
              .widgetWithText(CampoTextoFormulario, textoGradoAsignatura)
              .evaluate()
              .isNotEmpty,
          true);
    });

    testWidgets('Seleccionar fecha inicio...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FechaInicio));
      await tester.pumpAndSettle();

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('ACEPTAR'));

      DateFormat fecha = DateFormat('dd MMMM, yyyy');
      var fechaFormateada = fecha.format(DateTime.now());

      expect(find.widgetWithText(FechaInicio, fechaFormateada), findsOneWidget);
    });

    testWidgets('Seleccionar fecha fin...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FechaFin));
      await tester.pumpAndSettle();

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('ACEPTAR'));

      DateFormat fecha = DateFormat('dd MMMM, yyyy');
      var fechaFormateada = fecha.format(DateTime.now());

      expect(find.widgetWithText(FechaFin, fechaFormateada), findsOneWidget);
    });

    testWidgets('Seleccionar dias...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.text("lunes"));
      await tester.pumpAndSettle();
    });

    testWidgets(
      "Volver atrás",
      (tester) async {
        when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
        when(
          () => navigator.popAndPushNamed(calendarioRuta, arguments: usuario),
        ).thenAnswer((_) async {
          return CalendarioyClasesVista;
        });
        await tester.pumpWidget(testWidget);

        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.arrow_back));

        await tester.pumpAndSettle();

        verify(() =>
                navigator.popAndPushNamed(calendarioRuta, arguments: usuario))
            .called(1);
      },
    );

    testWidgets('Muestra snackBar cuando se produce un error', (tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        const AsignaturaError(
            excepcion: NoSePuedeEliminarAsignatura(), mensaje: 'Error'),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Muestra snackBar para informar', (tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        AsignaturaCargada(asignatura: asignaturaConLista, alumnos: alumnos),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
