import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockRepositorioAlumnos mockRepositorioAlumnos;
  late MockGeneradorPDF mockGeneradorPDF;
  late MockGeneradorClases mockGeneradorClases;
  late MockRepositorioListasAsistencia mockRepositorioListasAsistencia;
  late MockRepositorioClases mockRepositorioClases;
  late MockProcesadorExcel mockProcesadorExcel;
  late MockRepositorioAsignaturas mockRepositorioAsignaturas;
  late AsignaturaBloc asignaturaBloc;
  late Exception excepcion;
  late List<Asignatura> asignaturas;

  late List<ListaAsistenciasMes> listasAsistenciasMes;
  late List<ListaAsistenciasMes> listasAsistenciasMesSinActualizar;
  late List<ListaAsistenciasDia> listasAsistenciasDia;
  late UsuarioAutenticado usuario;
  late List<Clase> clases;

  late List<Alumno> alumnos;
  late List<AlumnoPDF> alumnosPDF;

  group('AsignaturaBloc test', () {
    setUp(() {
      EquatableConfig.stringify = true;
      mockRepositorioAlumnos = MockRepositorioAlumnos();
      mockGeneradorPDF = MockGeneradorPDF();
      mockGeneradorClases = MockGeneradorClases();
      mockRepositorioListasAsistencia = MockRepositorioListasAsistencia();
      mockRepositorioClases = MockRepositorioClases();
      mockProcesadorExcel = MockProcesadorExcel();
      mockRepositorioAsignaturas = MockRepositorioAsignaturas();

      alumnos = List.generate(
          5,
          (i) => Alumno(
              nipAlumno: '$i',
              nombreCompleto: 'Javier Ramos',
              dniAlumno: '18434454F',
              presente: false));

      clases = List.generate(
          3,
          (i) => Clase(
              idClase: '$i',
              idAsignatura: '4567',
              idProfesor: '32332',
              nombreAsignatura: 'Matemáticas',
              diaClase: DateTime.now(),
              nombreGrado: 'Informática',
              alumnos: alumnos,
              listaPasada: false));

      usuario = const UsuarioAutenticado(
          id: '2122', email: 'prueba@gmail.com', emailVerificado: true);

      listasAsistenciasDia = List.generate(
          3,
          (i) => ListaAsistenciasDia(
              idListaAsistenciasDia: '$i',
              idAsignatura: '533442',
              alumnos: alumnos,
              fecha: DateTime.now()));

      listasAsistenciasMes = List.generate(
          3,
          (i) => ListaAsistenciasMes(
              idListaAsistenciasMes: '$i',
              mes: 5,
              anyo: 2022,
              idAsignatura: '4564',
              listaAsistenciasDia: listasAsistenciasDia));

      listasAsistenciasMesSinActualizar = List.generate(
          2,
          (i) => ListaAsistenciasMes(
              idListaAsistenciasMes: '$i',
              mes: 5,
              anyo: 2022,
              idAsignatura: '4564',
              listaAsistenciasDia: listasAsistenciasDia));

      asignaturas = List.generate(
          4,
          (i) => Asignatura(
              dias: const ["1", "3"],
              fechaFin: DateTime.now().add(const Duration(days: 4)),
              fechaInicio: DateTime.now(),
              idAlumnos: const ["343", "454", "454545"],
              idAsignatura: '544534',
              listasAsistenciasMes: const [],
              nombreAsignatura: 'Matemáticas',
              nombreGrado: 'Informática',
              idProfesor: '545535'));

      alumnosPDF = List.generate(
          5,
          (i) => AlumnoPDF(
              asistencias: const {},
              nipAlumno: '$i',
              nombreCompleto: 'Javier'));

      asignaturaBloc = AsignaturaBloc(
        generadorPDF: mockGeneradorPDF,
        repositorioAlumnos: mockRepositorioAlumnos,
        generadorClases: mockGeneradorClases,
        procesadorExcel: mockProcesadorExcel,
        repositorioAsignaturas: mockRepositorioAsignaturas,
        repositorioClases: mockRepositorioClases,
        repositorioListasAsistencia: mockRepositorioListasAsistencia,
      );

      excepcion = const ExcepcionGenerica();
    });

    group('cargar lista de alumnos', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        'Emite [AlumnosCargados(alumnos)] cuando se llama a CargarListaAlumnos',
        setUp: () {
          when(() => mockProcesadorExcel.procesar())
              .thenAnswer((_) async => alumnos);

          for (var alumno in alumnos) {
            when(() => mockRepositorioAlumnos.crearAlumno(alumno))
                .thenAnswer((_) async => Future<void>.value());
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(const CargarListaAlumnos()),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AlumnosCargados(alumnos),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError(excepcion),
       EstadoAnyadirAsignatura] cuando hay una excepcion''',
        setUp: () {
          when(() => mockProcesadorExcel.procesar())
              .thenAnswer((_) async => alumnos);

          for (var alumno in alumnos) {
            when(() => mockRepositorioAlumnos.crearAlumno(alumno))
                .thenThrow(excepcion);
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(const CargarListaAlumnos()),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se ha podido cargar la lista de alumnos, vuelva a intentarlo'),
          const AsignaturaAnyadida(),
        ],
      );
    });

    group('crear clases', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        'Emite [EstadoClasesCreadas()] cuando se llama a CrearClases',
        setUp: () {
          when(() => mockGeneradorClases.crearClases(
              asignatura: asignaturas.first,
              alumnos: alumnos)).thenAnswer((_) => clases);

          for (var clase in clases) {
            when(() => mockRepositorioClases.crearClase(clase))
                .thenAnswer((_) async => Future<void>.value());
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc
            .add(CrearClases(alumnos: alumnos, asignatura: asignaturas.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          const ClasesCreadas(),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError(excepcion),
       EstadoAnyadirAsignatura] cuando hay una excepcion en CrearClases''',
        setUp: () {
          when(() => mockGeneradorClases.crearClases(
              asignatura: asignaturas.first,
              alumnos: alumnos)).thenAnswer((_) => clases);

          for (var clase in clases) {
            when(() => mockRepositorioClases.crearClase(clase))
                .thenThrow(excepcion);
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc
            .add(CrearClases(alumnos: alumnos, asignatura: asignaturas.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se han podido crear las clases, vuelva a intentarlo'),
          const AsignaturaAnyadida(),
        ],
      );
    });

    group('eliminar asignatura', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaEliminadaCorrectamente] cuando se llama a 
            EliminarAsignatura''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.eliminarAsignatura(
                  idAsignatura: asignaturas.first.idAsignatura))
              .thenAnswer((_) async => Future<void>.value());

          when(() => mockRepositorioClases.eliminarClases(
                  idAsignatura: asignaturas.first.idAsignatura))
              .thenAnswer((_) async => Future<void>.value());

          when(() => mockRepositorioAlumnos.eliminarAsignaturEnAlumno(
                  idAsignatura: asignaturas.first.idAsignatura))
              .thenAnswer((_) async => Future<void>.value());
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(EliminarAsignatura(
          idAsignatura: asignaturas.first.idAsignatura,
          idUsuario: usuario.id,
        )),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaEliminadaCorrectamente(
              idAsignatura: asignaturas.first.idAsignatura),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError()] cuando se produce una excepcion 
      en la llamada a EliminarAsignatura''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.eliminarAsignatura(
                  idAsignatura: asignaturas.first.idAsignatura))
              .thenThrow(excepcion);
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(EliminarAsignatura(
          idAsignatura: asignaturas.first.idAsignatura,
          idUsuario: usuario.id,
        )),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se ha podido eliminar la asignatura, vuelva a intentarlo'),
        ],
      );
    });

    group('actualizar listas de asistencia', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [ListasActualizadas()] cuando se llama a 
        ActualizarListasAsistenciaDia y la listaAsistenciaMesSinActualizar no esta vacia''',
        setUp: () {
          List<ListaAsistenciasDia> listaAsistencias = [];
          listaAsistencias.add(listasAsistenciasDia.first);

          ListaAsistenciasMes listaAsistenciasMes = ListaAsistenciasMes(
              anyo: listasAsistenciasDia.first.fecha.year,
              idAsignatura: listasAsistenciasDia.first.idAsignatura,
              idListaAsistenciasMes: listasAsistenciasDia.first.idAsignatura +
                  listasAsistenciasDia.first.fecha.month.toString() +
                  listasAsistenciasDia.first.fecha.year.toString(),
              listaAsistenciasDia: listaAsistencias,
              mes: listasAsistenciasDia.first.fecha.month);

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((_) async => listasAsistenciasMesSinActualizar);

          when(() =>
                  mockRepositorioListasAsistencia.actualizarListaAsistenciasMes(
                      listaAsistenciasDia: listasAsistenciasDia.first,
                      listaAsistenciasMes: listaAsistenciasMes))
              .thenAnswer((_) async => Future<void>.value());

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((invocation) async => listasAsistenciasMes);

          if (listasAsistenciasMesSinActualizar.isEmpty) {
            when(() => mockRepositorioAsignaturas
                    .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
                        idAsignatura: listasAsistenciasDia.first.idAsignatura,
                        listaAsistenciasMesActualizada:
                            listasAsistenciasMes.first))
                .thenAnswer((invocation) async => Future<void>.value());
          } else {
            when(() => mockRepositorioAsignaturas
                .actualizarListasAsistenciasMesEnAsignatura(
                    idAsignatura: listasAsistenciasDia.first.idAsignatura,
                    listaAsistenciasMesActualizada: listasAsistenciasMes.first,
                    listaAsistenciasMesSinActualizar:
                        listasAsistenciasMesSinActualizar.first)).thenAnswer(
                (invocation) async => Future<void>.value());
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(ActualizarListasAsistenciaDia(
            listaAsistenciasDia: listasAsistenciasDia.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          const ListasActualizadas(),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [ListasActualizadas()] cuando se llama a 
        ActualizarListasAsistenciaDia y la listaAsistenciaMesSinActualizar esta vacia''',
        setUp: () {
          List<ListaAsistenciasDia> listaAsistencias = [];
          listaAsistencias.add(listasAsistenciasDia.first);

          ListaAsistenciasMes listaAsistenciasMes = ListaAsistenciasMes(
              anyo: listasAsistenciasDia.first.fecha.year,
              idAsignatura: listasAsistenciasDia.first.idAsignatura,
              idListaAsistenciasMes: listasAsistenciasDia.first.idAsignatura +
                  listasAsistenciasDia.first.fecha.month.toString() +
                  listasAsistenciasDia.first.fecha.year.toString(),
              listaAsistenciasDia: listaAsistencias,
              mes: listasAsistenciasDia.first.fecha.month);

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((_) async => listasAsistenciasMesSinActualizar);

          when(() =>
                  mockRepositorioListasAsistencia.actualizarListaAsistenciasMes(
                      listaAsistenciasDia: listasAsistenciasDia.first,
                      listaAsistenciasMes: listaAsistenciasMes))
              .thenAnswer((_) async => Future<void>.value());

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((invocation) async => listasAsistenciasMes);

          if (listasAsistenciasMesSinActualizar.isEmpty) {
            when(() => mockRepositorioAsignaturas
                    .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
                        idAsignatura: listasAsistenciasDia.first.idAsignatura,
                        listaAsistenciasMesActualizada:
                            listasAsistenciasMes.first))
                .thenAnswer((invocation) async => Future<void>.value());
          } else {
            when(() => mockRepositorioAsignaturas
                .actualizarListasAsistenciasMesEnAsignatura(
                    idAsignatura: listasAsistenciasDia.first.idAsignatura,
                    listaAsistenciasMesActualizada: listasAsistenciasMes.first,
                    listaAsistenciasMesSinActualizar:
                        listasAsistenciasMesSinActualizar.first)).thenAnswer(
                (invocation) async => Future<void>.value());
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(ActualizarListasAsistenciaDia(
            listaAsistenciasDia: listasAsistenciasDia.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          const ListasActualizadas(),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError] cuando se llama a 
        ActualizarListasAsistenciaDia y se produce una excepcion''',
        setUp: () {
          List<ListaAsistenciasDia> listaAsistencias = [];
          listaAsistencias.add(listasAsistenciasDia.first);

          ListaAsistenciasMes listaAsistenciasMes = ListaAsistenciasMes(
              anyo: listasAsistenciasDia.first.fecha.year,
              idAsignatura: listasAsistenciasDia.first.idAsignatura,
              idListaAsistenciasMes: listasAsistenciasDia.first.idAsignatura +
                  listasAsistenciasDia.first.fecha.month.toString() +
                  listasAsistenciasDia.first.fecha.year.toString(),
              listaAsistenciasDia: listaAsistencias,
              mes: listasAsistenciasDia.first.fecha.month);

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((_) async => listasAsistenciasMesSinActualizar);

          when(() =>
                  mockRepositorioListasAsistencia.actualizarListaAsistenciasMes(
                      listaAsistenciasDia: listasAsistenciasDia.first,
                      listaAsistenciasMes: listaAsistenciasMes))
              .thenThrow(excepcion);

          when(() => mockRepositorioListasAsistencia.obtenerListaAsistenciasMes(
                  anyo: listasAsistenciasDia.first.fecha.year,
                  idAsignatura: listasAsistenciasDia.first.idAsignatura,
                  mes: listasAsistenciasDia.first.fecha.month))
              .thenAnswer((invocation) async => listasAsistenciasMes);

          if (listasAsistenciasMesSinActualizar.isEmpty) {
            when(() => mockRepositorioAsignaturas
                    .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
                        idAsignatura: listasAsistenciasDia.first.idAsignatura,
                        listaAsistenciasMesActualizada:
                            listasAsistenciasMes.first))
                .thenAnswer((invocation) async => Future<void>.value());
          } else {
            when(() => mockRepositorioAsignaturas
                .actualizarListasAsistenciasMesEnAsignatura(
                    idAsignatura: listasAsistenciasDia.first.idAsignatura,
                    listaAsistenciasMesActualizada: listasAsistenciasMes.first,
                    listaAsistenciasMesSinActualizar:
                        listasAsistenciasMesSinActualizar.first)).thenAnswer(
                (invocation) async => Future<void>.value());
          }
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(ActualizarListasAsistenciaDia(
            listaAsistenciasDia: listasAsistenciasDia.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se ha podido guardar la lista de asistencia, vuelva a intentarlo'),
        ],
      );
    });
    group('Obtener Asignaturas', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [AsignaturasUsuarioObtenidas] cuando se llama a 
        ObtenerAsignaturas''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.obtenerAsignaturasUsuario(
                  idUsuario: usuario.id))
              .thenAnswer((invocation) async => asignaturas);
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(ObtenerAsignaturas(idUsuario: usuario.id)),
        expect: () => <EstadoAsignatura>[
          AsignaturasUsuarioObtenidas(asignaturas: asignaturas),
        ],
      );
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError] cuando se llama a 
        ObtenerAsignaturas y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.obtenerAsignaturasUsuario(
              idUsuario: usuario.id)).thenThrow(excepcion);
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(ObtenerAsignaturas(idUsuario: usuario.id)),
        expect: () => <EstadoAsignatura>[
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se ha podido obtener la asignatura, vuelva a intentarlo'),
        ],
      );
    });

    group('Generar PDF', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [AsignaturasUsuarioObtenidas] cuando se llama a 
        ObtenerAsignaturas''',
        setUp: () {
          when(() => mockGeneradorPDF.generarAlumnosPdf(
              listaAsistenciasMes: listasAsistenciasMes.first,
              asignatura: asignaturas.first)).thenAnswer((_) => alumnosPDF);

          when(() => mockGeneradorPDF.generarPdf(
                  alumnos: alumnosPDF,
                  listaAsistencias: listasAsistenciasMes.first))
              .thenAnswer((invocation) async => Uint8List(5));
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(GenerarPDF(
            listaAsistenciasMes: listasAsistenciasMes.first,
            asignatura: asignaturas.first)),
        expect: () => <EstadoAsignatura>[
          PdfGenerado(
              pdf: Uint8List(5),
              listaAsistenciaMes: listasAsistenciasMes.first),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [AsignaturaError] cuando se llama a 
        GenerarPDF y se produce una excepcion''',
        setUp: () {
          when(() => mockGeneradorPDF.generarAlumnosPdf(
              listaAsistenciasMes: listasAsistenciasMes.first,
              asignatura: asignaturas.first)).thenAnswer((_) => alumnosPDF);

          when(() => mockGeneradorPDF.generarPdf(
                  alumnos: alumnosPDF,
                  listaAsistencias: listasAsistenciasMes.first))
              .thenThrow(excepcion);
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(GenerarPDF(
            listaAsistenciasMes: listasAsistenciasMes.first,
            asignatura: asignaturas.first)),
        expect: () => <EstadoAsignatura>[
          AsignaturaError(
              excepcion: excepcion,
              mensaje: 'No se ha podido generar el PDF, vuelve a intenterlo'),
        ],
      );
    });

    group('Editar Lista Asistencias En Asignatura', () {
      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [AsignaturasUsuarioObtenidas] cuando se llama a 
        ObtenerAsignaturas''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.editarListaAsistenciasDia(
                  asignatura: asignaturas.first,
                  listaAsistenciasMesSinEditar: listasAsistenciasMes.first))
              .thenAnswer((_) async => Future<void>.value());
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(EditarListaEnAsignatura(
            asignatura: asignaturas.first,
            listaAsistenciasMesSinEditar: listasAsistenciasMes.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          const ListaAsistenciasEditadaEnAsignatura(),
        ],
      );

      blocTest<AsignaturaBloc, EstadoAsignatura>(
        '''Emite [EstadoAsignaturaError] cuando se llama a 
        EditarListaEnAsignatura y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAsignaturas.editarListaAsistenciasDia(
                  asignatura: asignaturas.first,
                  listaAsistenciasMesSinEditar: listasAsistenciasMes.first))
              .thenThrow(excepcion);
        },
        build: () => asignaturaBloc,
        act: (bloc) => bloc.add(EditarListaEnAsignatura(
            asignatura: asignaturas.first,
            listaAsistenciasMesSinEditar: listasAsistenciasMes.first)),
        expect: () => <EstadoAsignatura>[
          const AsignaturaCargando(),
          AsignaturaError(
              excepcion: excepcion,
              mensaje:
                  'No se ha podido editar la lista de asistencias, vuelva a intentarlo'),
        ],
      );
    });
  });
}
