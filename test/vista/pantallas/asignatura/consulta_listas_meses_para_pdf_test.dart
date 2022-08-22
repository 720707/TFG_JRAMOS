import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/consulta_listas_meses_para_pdf.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/asignatura/listado_opciones_asignatura.dart';
import 'package:control_asistencia_tfg_jrm/vista/rutas/generador_rutas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AsignaturaBloc asignaturaBloc;
  late MockNavigator navigator;

  late GeneradorDeRutas generadorDeRutas;

  setUpAll(() {
    asignaturaBloc = MockAsignaturaBloc();
    navigator = MockNavigator();

    generadorDeRutas = GeneradorDeRutas();
  });
  group('Listas meses para pdf vista', () {
    testWidgets('Muestra texto si no hay asignaturas ...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(BlocProvider<AsignaturaBloc>(
        create: (context) => asignaturaBloc,
        child: MaterialApp(
            home: ConsultaListasMesesParaPdfVista(
          asignatura: asignaturaSinLista,
          usuario: usuario,
        )),
      ));

      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.text(textoNoHayPDFs), findsNWidgets(1));
      expect(find.text('PDF - ${asignaturaSinLista.nombreAsignatura}'),
          findsNWidgets(1));
    });

    testWidgets('Muestra listview si hay asignaturas ...', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      await tester.pumpWidget(BlocProvider<AsignaturaBloc>(
        create: (context) => asignaturaBloc,
        child: MaterialApp(
            home: ConsultaListasMesesParaPdfVista(
          asignatura: asignaturaConLista,
          usuario: usuario,
        )),
      ));
      expect(find.byType(MiAppBar), findsNWidgets(1));
      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(MiListTile), findsWidgets);
    });

    testWidgets('Muestra snackBar cuando se produce un error',
        (WidgetTester tester) async {
      final estadosEsperados = [
        AsignaturaInitial(),
        const AsignaturaError(
            excepcion: NoSePuedeEliminarAsignatura(), mensaje: 'Error'),
      ];
      whenListen(asignaturaBloc,
          Stream<EstadoAsignatura>.fromIterable(estadosEsperados),
          initialState: AsignaturaInitial());

      await tester.pumpWidget(BlocProvider<AsignaturaBloc>(
        create: (context) => asignaturaBloc,
        child: MaterialApp(
            home: ConsultaListasMesesParaPdfVista(
          asignatura: asignaturaConLista,
          usuario: usuario,
        )),
      ));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Vuelver atrás al pulsar la flecha ', (tester) async {
      when(() => asignaturaBloc.state).thenReturn(AsignaturaInitial());
      when(
        () => navigator.popAndPushNamed(opcionesAsignaturasRuta,
            arguments: any(named: 'arguments')),
      ).thenAnswer((_) async {
        return OpcionesAsignaturaVista;
      });

      await tester.pumpWidget(BlocProvider<AsignaturaBloc>(
        create: (context) => asignaturaBloc,
        child: MaterialApp(
            onGenerateRoute: generadorDeRutas.generarRuta,
            home: MockNavigatorProvider(
              navigator: navigator,
              child: ConsultaListasMesesParaPdfVista(
                asignatura: asignaturaConLista,
                usuario: usuario,
              ),
            )),
      ));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.arrow_back));

      await tester.pump();

      verify(() => navigator.popAndPushNamed(opcionesAsignaturasRuta,
          arguments: any(named: 'arguments'))).called(1);
    });
  });
}
