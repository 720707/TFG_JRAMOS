import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockRepositorioListasAsistencia mockRepositorioListasAsistencia;
  late MockRepositorioClases mockRepositorioClases;
  late ListasAsistenciaBloc listasAsistenciaBloc;

  late Clase clase;
  late ListaAsistenciasDia listaAsistenciasDia;
  late Exception excepcion;
  late Asignatura asignatura;
  late ListaAsistenciasMes listaAsistenciaMes;

  group('Listas Asistencias Bloc', () {
    setUp(() {
      EquatableConfig.stringify = true;
      mockRepositorioClases = MockRepositorioClases();
      mockRepositorioListasAsistencia = MockRepositorioListasAsistencia();
      excepcion = const ExcepcionGenerica();
      listasAsistenciaBloc = ListasAsistenciaBloc(
          repositorioListasAsistencia: mockRepositorioListasAsistencia,
          repositorioClases: mockRepositorioClases);
      listaAsistenciasDia = ListaAsistenciasDia(
          idListaAsistenciasDia: '5345',
          idAsignatura: '5345',
          alumnos: const [],
          fecha: DateTime.now());

      clase = Clase(
          alumnos: const [],
          diaClase: DateTime.now(),
          idProfesor: '434',
          idAsignatura: '5345',
          idClase: '5445',
          nombreGrado: 'Informática',
          listaPasada: false,
          nombreAsignatura: 'Bases de Datos');
      asignatura = Asignatura(
          dias: const [],
          idAsignatura: '5345',
          fechaFin: DateTime.now(),
          idAlumnos: const [],
          idProfesor: '434',
          fechaInicio: DateTime.now(),
          listasAsistenciasMes: const [],
          nombreAsignatura: 'Bases de Datos',
          nombreGrado: 'Informática');
      listaAsistenciaMes = const ListaAsistenciasMes(
          idListaAsistenciasMes: '43443',
          mes: 6,
          anyo: 2022,
          idAsignatura: '5445',
          listaAsistenciasDia: []);
    });

    group('Pasar Lista Dia', () {
      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        'Emite [ClasesCargadas] cuando se llama a PasarListaDia',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.pasarListaAsistenciasDia(
              listaAsistenciasDia)).thenAnswer((_) async => Future<void>.value);

          when(() => mockRepositorioClases.ponerListaPasadaATrue(clase))
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) => bloc.add(PasarListaDia(
            clase: clase, listaAsistenciasDia: listaAsistenciasDia)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          ListaAsistenciasDiaPasada(listaAsistenciasDia)
        ],
      );

      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        '''Emite [EstadoListasAsistenciasError] cuando se manda el evento
        PasarListaDia y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.pasarListaAsistenciasDia(
              listaAsistenciasDia)).thenAnswer((_) async => Future<void>.value);

          when(() => mockRepositorioClases.ponerListaPasadaATrue(clase))
              .thenThrow(excepcion);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) => bloc.add(PasarListaDia(
            clase: clase, listaAsistenciasDia: listaAsistenciasDia)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          ListasAsistenciasError(excepcion: excepcion)
        ],
      );
    });

    group('Evento EliminarListasAsistenciaDiayMes', () {
      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        '''Emite [ListasAsistenciaEliminadasCorrectamente] cuando se
         llama a PasarListaDia''',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.eliminarListasAsistencia(
                  idAsignatura: asignatura.idAsignatura))
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) => bloc.add(EliminarListasAsistenciaDiayMes(
            idAsignatura: asignatura.idAsignatura)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          const ListasAsistenciaEliminadas()
        ],
      );

      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        '''Emite [EstadoListasAsistenciasError] cuando se
         emite el evento PasarListaDia y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.eliminarListasAsistencia(
              idAsignatura: asignatura.idAsignatura)).thenThrow(excepcion);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) => bloc.add(EliminarListasAsistenciaDiayMes(
            idAsignatura: asignatura.idAsignatura)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          ListasAsistenciasError(excepcion: excepcion)
        ],
      );
    });

    group('Evento Editar Lista Dia', () {
      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        '''Emite [EstadoListaAsistenciasEditada] cuando se
         llama a EventoEditarListaDia''',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.editarListaAsistenciaDia(
                  listaAsistencias: listaAsistenciasDia))
              .thenAnswer((_) async => listaAsistenciaMes);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) =>
            bloc.add(EditarListaDia(listaAsistenciasDia: listaAsistenciasDia)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          ListaAsistenciasEditada(
              listaAsistenciasMesSinEditar: listaAsistenciaMes),
        ],
      );

      blocTest<ListasAsistenciaBloc, EstadoListasAsistencia>(
        '''Emite [EstadoListasAsistenciasError] cuando se
         envia el evento EventoEditarListaDia y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioListasAsistencia.editarListaAsistenciaDia(
              listaAsistencias: listaAsistenciasDia)).thenThrow(excepcion);
        },
        build: () => listasAsistenciaBloc,
        act: (bloc) =>
            bloc.add(EditarListaDia(listaAsistenciasDia: listaAsistenciasDia)),
        expect: () => <EstadoListasAsistencia>[
          const ListasAsistenciaCargando(),
          ListasAsistenciasError(excepcion: excepcion),
        ],
      );
    });
  });
}
