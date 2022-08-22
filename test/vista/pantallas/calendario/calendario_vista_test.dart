import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/calendario/calendario_bloc.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/entidades.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/pantallas.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late CalendarioBloc calendarioBloc;
  late MockNavigator navigator;
  late Widget testWidget;
  late MockRepositorioClases mockRepositorioClases;
  late AutenticacionBloc autenticacionBloc;

  late Stream<Iterable<Clase>> clasesStream;
  late Stream<Iterable<Clase>> clasesStreamVacias;
  setUp(() {
    mockRepositorioClases = MockRepositorioClases();
    navigator = MockNavigator();
    autenticacionBloc = MockAutenticacionBloc();
    clasesStream = Stream.value(clases);
    clasesStreamVacias = Stream.value([]);

    calendarioBloc = MockCalendarioBloc();
    testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<CalendarioBloc>(
          create: (context) => calendarioBloc,
        ),
        BlocProvider<AutenticacionBloc>(
          create: (context) => autenticacionBloc,
        ),
      ],
      child: MaterialApp(
        home: Localizations(
            delegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            locale: const Locale('es'),
            child: MockNavigatorProvider(
              navigator: navigator,
              child: CalendarioyClasesVista(
                usuario: usuario,
              ),
            )),
      ),
    );
  });

  group('Calendario Vista', () {
    testWidgets(
      "Muestra CircularProgressIndicator si no hay datos",
      (WidgetTester tester) async {
        when(() => calendarioBloc.state)
            .thenReturn(const ClasesCargadas(clases: Stream.empty()));

        await tester.pumpWidget(testWidget);
        await tester.pump();

        expect(find.byType(PopupMenuOpciones), findsNWidgets(1));
        expect(find.byType(CircularProgressIndicator), findsNWidgets(1));
      },
    );

    testWidgets(
      "Muestra ClasesDia si hay clases",
      (WidgetTester tester) async {
        when(() => calendarioBloc.state)
            .thenReturn(ClasesCargadas(clases: clasesStream));

        await tester.pumpWidget(testWidget);
        await tester.pump();
        when(() => mockRepositorioClases.obtenerClasesUsuario(
            idUsuario: usuario.id)).thenAnswer((_) => clasesStream);
        await tester.pump();

        expect(find.byType(ClasesDia), findsNWidgets(1));
        expect(find.byType(ListTile), findsWidgets);
      },
    );

    //Habria que mockear la navegacion - No esta bien
    testWidgets(
      "Navega cuando se pulsa ClasesDia",
      (WidgetTester tester) async {
        when(() => calendarioBloc.state)
            .thenReturn(ClasesCargadas(clases: clasesStream));
        when(() => navigator.pushNamed(pasarListaClaseRuta,
            arguments: any(named: 'arguments'))).thenAnswer((_) async {
          return RegistroVista;
        });

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ListTile).first);

        verify(() => navigator.pushNamed(pasarListaClaseRuta,
            arguments: any(named: 'arguments'))).called(1);
      },
    );

    testWidgets(
      "No muestra claseDia si vamos a un dia sin clases",
      (WidgetTester tester) async {
        when(() => calendarioBloc.state)
            .thenReturn(ClasesCargadas(clases: clasesStreamVacias));

        await tester.pumpWidget(testWidget);
        await tester.pump();

        expect(find.byType(ListTile), findsNothing);
      },
    );
  });
}
