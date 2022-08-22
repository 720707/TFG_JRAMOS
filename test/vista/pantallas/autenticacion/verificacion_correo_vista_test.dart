import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/vista/pantallas/autenticacion/verificacion_correo_vista.dart';
import 'package:control_asistencia_tfg_jrm/vista/widgets/appBar/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../mocks/mocks.dart';

void main() {
  late AutenticacionBloc autenticacionBloc;
  setUp(() {
    autenticacionBloc = MockAutenticacionBloc();
  });

  group('Verificar correo vista test', () {
    testWidgets('Elementos visibles correctamente al cargar la vista ...',
        (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: VerificacionCorreoVista()));

      expect(find.byType(MiAppBar), findsOneWidget);

      expect(find.text('Abre tu correo para confirmar la cuenta.'),
          findsOneWidget);
      expect(
          find.text('Volver a enviar email de confirmación'), findsOneWidget);
    });

    testWidgets('Enviar evento al pulsar el boton ...', (tester) async {
      await tester.pumpWidget(BlocProvider<AutenticacionBloc>(
          create: (context) => autenticacionBloc,
          child: const MaterialApp(home: VerificacionCorreoVista())));

      await tester.tap(find.text('Volver a enviar email de confirmación'));
      verify(() => autenticacionBloc.add(const EviarEmailVerificacion()))
          .called(1);
    });
  });
}
