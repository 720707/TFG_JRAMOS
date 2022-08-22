import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockProveedorAsignaturas mockProveedorAsignaturas;
  late RepositorioAsignaturas repositorioAsignaturas;

  late UsuarioAutenticado usuario;
  late List<Asignatura> asignaturas;
  late ListaAsistenciasMes listaAsistenciasMesSinActualizar;
  late ListaAsistenciasMes listaAsistenciasMesActualizada;

  setUpAll(() {
    mockProveedorAsignaturas = MockProveedorAsignaturas();
    repositorioAsignaturas =
        RepositorioAsignaturas(proveedorAsignaturas: mockProveedorAsignaturas);

    usuario = const UsuarioAutenticado(
        email: 'preuba@gmail.com', emailVerificado: false, id: '43443');
    asignaturas = List.generate(
        4,
        (index) => Asignatura(
            idAsignatura: '4343',
            idProfesor: '4343',
            nombreAsignatura: 'Matemáticas',
            fechaInicio: DateTime.now(),
            fechaFin: DateTime.now(),
            dias: const [],
            nombreGrado: 'informática',
            idAlumnos: const [],
            listasAsistenciasMes: const []));

    listaAsistenciasMesSinActualizar = const ListaAsistenciasMes(
        anyo: 2022,
        listaAsistenciasDia: [],
        idAsignatura: '',
        idListaAsistenciasMes: '',
        mes: 3);

    listaAsistenciasMesActualizada = const ListaAsistenciasMes(
        anyo: 2022,
        listaAsistenciasDia: [],
        idAsignatura: '',
        idListaAsistenciasMes: '',
        mes: 3);
  });

  group('Repositorio Asignaturas Test', () {
    test('Añadir Asignatura', () {
      //arrange
      when(() => mockProveedorAsignaturas.anyadirAsignatura(
              asignatura: asignaturas.first))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado =
          repositorioAsignaturas.anyadirAsignatura(asignaturas.first);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorAsignaturas.anyadirAsignatura(
          asignatura: asignaturas.first)).called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test('Añadir Asignatura lanza una excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAsignaturas.anyadirAsignatura(
              asignatura: asignaturas.first))
          .thenThrow(const NoSePuedeAnyadirAsignaturaAAlumno());
      //act
      try {
        repositorioAsignaturas.anyadirAsignatura(asignaturas.first);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAsignaturas.anyadirAsignatura(
            asignatura: asignaturas.first)).called(1);
        verifyNoMoreInteractions(mockProveedorAsignaturas);
      }
    });

    test('Obtener Asignaturas Usuario', () async {
      //arrange
      when(() => mockProveedorAsignaturas.obtenerAsignaturasUsuario(
          idUsuario: usuario.id)).thenAnswer((_) async => asignaturas);
      //act
      final resultado = await repositorioAsignaturas.obtenerAsignaturasUsuario(
          idUsuario: usuario.id);
      //assert
      expect(resultado, isA<List<Asignatura>>());
      expect(resultado, equals(asignaturas));
      verify(() => mockProveedorAsignaturas.obtenerAsignaturasUsuario(
          idUsuario: usuario.id)).called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test('Actualizar Listas Asistencias Mes En Asignatura', () {
      //arrange
      when(() =>
          mockProveedorAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
              idAsignatura: asignaturas.first.idAsignatura,
              listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
              listaAsistenciasMesSinActualizar:
                  listaAsistenciasMesActualizada)).thenAnswer(
          (_) async => Future<void>.value);
      //act
      final resultado =
          repositorioAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
              idAsignatura: asignaturas.first.idAsignatura,
              listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
              listaAsistenciasMesSinActualizar: listaAsistenciasMesActualizada);
      //assert
      expect(resultado, isA<Future<void>>());
      verify(() =>
          mockProveedorAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
              idAsignatura: asignaturas.first.idAsignatura,
              listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
              listaAsistenciasMesSinActualizar:
                  listaAsistenciasMesActualizada)).called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test(
        'Actualizar Listas Asistencias Mes En Asignatura lanza excepcion en caso de fallo',
        () {
      //arrange
      when(() =>
          mockProveedorAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
              idAsignatura: asignaturas.first.idAsignatura,
              listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
              listaAsistenciasMesSinActualizar:
                  listaAsistenciasMesActualizada)).thenThrow(
          const NoSePuedeActualizarListaAsistenciaEnAsignatura());
      //act
      try {
        repositorioAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
            idAsignatura: asignaturas.first.idAsignatura,
            listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
            listaAsistenciasMesSinActualizar: listaAsistenciasMesActualizada);
      } on Exception catch (e) {
        expect(e, isA<ExcepcionBaseDeDatos>());
        //assert
        verify(() =>
            mockProveedorAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
                idAsignatura: asignaturas.first.idAsignatura,
                listaAsistenciasMesActualizada:
                    listaAsistenciasMesSinActualizar,
                listaAsistenciasMesSinActualizar:
                    listaAsistenciasMesActualizada)).called(1);
        verifyNoMoreInteractions(mockProveedorAsignaturas);
      }
    });

    test('Actualizar Listas Asistencias Mes En Asignatura Sin Lista Previa',
        () {
      //arrange
      when(() => mockProveedorAsignaturas
              .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
            idAsignatura: asignaturas.first.idAsignatura,
            listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
          )).thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAsignaturas
          .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
        idAsignatura: asignaturas.first.idAsignatura,
        listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
      );
      //assert
      expect(resultado, isA<Future<void>>());
      verify(() => mockProveedorAsignaturas
              .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
            idAsignatura: asignaturas.first.idAsignatura,
            listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
          )).called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test(
        '''Actualizar Listas Asistencias Mes En Asignatura Sin Lista Previa
      lanza excepcion en caso de fallo''',
        () {
      //arrange
      when(() => mockProveedorAsignaturas
              .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
            idAsignatura: asignaturas.first.idAsignatura,
            listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
          )).thenThrow(const NoSePuedeActualizarListaAsistenciaEnAsignatura());
      //act
      try {
        repositorioAsignaturas
            .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
          idAsignatura: asignaturas.first.idAsignatura,
          listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
        );
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAsignaturas
                .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
              idAsignatura: asignaturas.first.idAsignatura,
              listaAsistenciasMesActualizada: listaAsistenciasMesSinActualizar,
            )).called(1);
        verifyNoMoreInteractions(mockProveedorAsignaturas);
      }
    });

    test('Eliminar Asignatura', () {
      //arrange

      when(() => mockProveedorAsignaturas.eliminarAsignatura(
            idAsignatura: asignaturas.first.idAsignatura,
          )).thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAsignaturas.eliminarAsignatura(
        idAsignatura: asignaturas.first.idAsignatura,
      );
      //assert
      expect(resultado, isA<Future<void>>());
      verify(() => mockProveedorAsignaturas.eliminarAsignatura(
            idAsignatura: asignaturas.first.idAsignatura,
          )).called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test('Eliminar Asignatura lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAsignaturas.eliminarAsignatura(
            idAsignatura: asignaturas.first.idAsignatura,
          )).thenThrow(const NoSePuedeEliminarAsignatura());
      //act
      try {
        repositorioAsignaturas.eliminarAsignatura(
          idAsignatura: asignaturas.first.idAsignatura,
        );
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAsignaturas.eliminarAsignatura(
              idAsignatura: asignaturas.first.idAsignatura,
            )).called(1);
        verifyNoMoreInteractions(mockProveedorAsignaturas);
      }
    });

    test('Editar Lista Asistencias Dia', () {
      //arrange
      when(() => mockProveedorAsignaturas.editarListaAsistenciasDia(
              asignatura: asignaturas.first,
              listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAsignaturas.editarListaAsistenciasDia(
          asignatura: asignaturas.first,
          listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar);
      //assert
      expect(resultado, isA<Future<void>>());
      verify(() => mockProveedorAsignaturas.editarListaAsistenciasDia(
              asignatura: asignaturas.first,
              listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar))
          .called(1);
      verifyNoMoreInteractions(mockProveedorAsignaturas);
    });

    test('Editar Lista Asistencias Dia lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAsignaturas.editarListaAsistenciasDia(
              asignatura: asignaturas.first,
              listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar))
          .thenThrow(const NoSePuedeEditarListaAsistenciaDiaEnAsignatura());
      //act
      try {
        repositorioAsignaturas.editarListaAsistenciasDia(
            asignatura: asignaturas.first,
            listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAsignaturas.editarListaAsistenciasDia(
                asignatura: asignaturas.first,
                listaAsistenciasMesSinEditar: listaAsistenciasMesSinActualizar))
            .called(1);
        verifyNoMoreInteractions(mockProveedorAsignaturas);
      }
    });
  });
}
