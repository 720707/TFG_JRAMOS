import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/calendario/calendario_bloc.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockRepositorioClases mockRepositorioClases;
  late CalendarioBloc calendarioBloc;
  late UsuarioAutenticado usuario;
  late Stream<Iterable<Clase>> clasesStream;

  group('Calendario Bloc Test', () {
    setUp(() {
      EquatableConfig.stringify = true;
      mockRepositorioClases = MockRepositorioClases();
      calendarioBloc = CalendarioBloc(repositorioClases: mockRepositorioClases);
      usuario = const UsuarioAutenticado(
          id: '2122', email: 'prueba@gmail.com', emailVerificado: true);
      clasesStream = const Stream.empty();
    });
    blocTest<CalendarioBloc, EstadoCalendario>(
      'Emite [ClasesCargadas] cuando se llama a EventoCargarClasesUsuario',
      setUp: () {
        when(() => mockRepositorioClases.obtenerClasesUsuario(
            idUsuario: usuario.id)).thenAnswer((_) => clasesStream);
      },
      build: () => calendarioBloc,
      act: (bloc) => bloc.add(CargarClasesUsuario(idUsuario: usuario.id)),
      expect: () => <EstadoCalendario>[
        ClasesCargadas(clases: clasesStream),
      ],
    );
  });
}
