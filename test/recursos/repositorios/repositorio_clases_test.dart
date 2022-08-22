import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockProveedorClases mockProveedorClases;
  late RepositorioClases repositorioClases;
  late Stream<Iterable<Clase>> clasesStream;
  late List<Clase> clases;
  late Asignatura asignatura;

  setUpAll(() {
    mockProveedorClases = MockProveedorClases();
    repositorioClases = RepositorioClases(proveedorClases: mockProveedorClases);
    asignatura = Asignatura(
        idAsignatura: '4343',
        idProfesor: '4343',
        nombreAsignatura: 'Matemáticas',
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now(),
        dias: const [],
        nombreGrado: 'informática',
        idAlumnos: const [],
        listasAsistenciasMes: const []);
    clases = List.generate(
        4,
        (index) => Clase(
            idClase: '$index',
            idAsignatura: '443',
            idProfesor: '5445',
            nombreAsignatura: 'Matemáticas',
            diaClase: DateTime.now(),
            nombreGrado: 'Informática',
            alumnos: const [],
            listaPasada: false));
  });

  group('Repositorio Clases Test', () {
    test('Crear Clase', () {
      //arrange
      when(() => mockProveedorClases.crearClase(clases.first))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioClases.crearClase(clases.first);
      //assert
      expect(resultado, isA<Future<void>>());
      verify(() => mockProveedorClases.crearClase(clases.first));
    });

    test('Crear Clase lanza una excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorClases.crearClase(clases.first))
          .thenThrow(const ExcepcionNoSePuedeCrearClase());
      //act
      try {
        repositorioClases.crearClase(clases.first);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorClases.crearClase(clases.first));
      }
    });

    test('Obtener Clases Usuario', () async {
      //arrange
      UsuarioAutenticado usuario = const UsuarioAutenticado(
          email: 'preuba@gmail.com', emailVerificado: false, id: '43443');

      clasesStream = Stream.value(clases);
      when(() =>
              mockProveedorClases.obtenerClasesUsuario(idUsuario: usuario.id))
          .thenAnswer((_) => clasesStream);
      //act
      final resultado =
          repositorioClases.obtenerClasesUsuario(idUsuario: usuario.id);
      //assert
      expect(resultado, isA<Stream<Iterable<Clase>>>());
      expect(resultado, equals(clasesStream));
      verify(() =>
          mockProveedorClases.obtenerClasesUsuario(idUsuario: usuario.id));
      verifyNoMoreInteractions(mockProveedorClases);
    });

    test('Eliminar Clase', () async {
      //arrange

      when(() => mockProveedorClases.eliminarClases(
              idAsignatura: asignatura.idAsignatura))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioClases.eliminarClases(
          idAsignatura: asignatura.idAsignatura);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorClases.eliminarClases(
          idAsignatura: asignatura.idAsignatura));
      verifyNoMoreInteractions(mockProveedorClases);
    });

    test('Eliminar Clase lanza excepcion en caso de fallo', () async {
      //arrange

      when(() => mockProveedorClases.eliminarClases(
              idAsignatura: asignatura.idAsignatura))
          .thenThrow(const NoSePuedenEliminarClases());
      //act
      try {
        repositorioClases.eliminarClases(idAsignatura: asignatura.idAsignatura);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorClases.eliminarClases(
            idAsignatura: asignatura.idAsignatura));
        verifyNoMoreInteractions(mockProveedorClases);
      }
    });

    test('Poner Lista Pasada A True', () async {
      //arrange

      when(() => mockProveedorClases.ponerListaPasadaATrue(clases.first))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioClases.ponerListaPasadaATrue(clases.first);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorClases.ponerListaPasadaATrue(clases.first));
      verifyNoMoreInteractions(mockProveedorClases);
    });

    test('Poner Lista Pasada A True lanza excepcion en caso de fallo',
        () async {
      //arrange
      when(() => mockProveedorClases.ponerListaPasadaATrue(clases.first))
          .thenThrow(const NoSeHaPodidoPonerListaPasadaATure());
      //act
      try {
        repositorioClases.ponerListaPasadaATrue(clases.first);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorClases.ponerListaPasadaATrue(clases.first));
        verifyNoMoreInteractions(mockProveedorClases);
      }
    });
  });
}
