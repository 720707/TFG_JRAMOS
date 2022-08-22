import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mocks.dart';
import '../../../utils/parametros.dart';

void main() {
  late AutenticacionBloc autenticacionBloc;
  late Widget testWidget;

  setUpAll(() {
    autenticacionBloc = MockAutenticacionBloc();
    testWidget = BlocProvider<AutenticacionBloc>(
      create: (context) => autenticacionBloc,
      child: MaterialApp(
          home: Card(
        child: PopupMenuOpciones(
          usuario: usuario,
        ),
      )),
    );
  });

  group('Popup Menu test', () {
    testWidgets('Abrir popup menu opciones ...', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.text(cerrarSesion), findsNothing);
      expect(find.text(borrarCuenta), findsNothing);
      expect(find.text(mostrarAsignaturas), findsNothing);
      expect(find.text(anyadirAsignatura), findsNothing);

      await tester.tap(find.byType(PopupMenuOpciones));
      await tester.pumpAndSettle();
      expect(find.text(cerrarSesion), findsOneWidget);
      expect(find.text(borrarCuenta), findsOneWidget);
      expect(find.text(mostrarAsignaturas), findsOneWidget);
      expect(find.text(anyadirAsignatura), findsOneWidget);
    });
  });
}
