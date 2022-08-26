import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/entidades.dart';
import 'package:control_asistencia_tfg_jrm/recursos/repositorios/respositorio_alumnos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockProveedorAlumnos mockProveedorAlumnos;
  late RepositorioAlumnos repositorioAlumnos;
  late Alumno alumno;
  late Asignatura asignatura;
  setUpAll(() {
    mockProveedorAlumnos = MockProveedorAlumnos();
    repositorioAlumnos =
        RepositorioAlumnos(proveedorAlumnos: mockProveedorAlumnos);
    alumno = Alumno(
      dniAlumno: '43',
      nipAlumno: '344',
      nombreCompleto: '3443',
      presente: false,
    );
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
  });

  group('Repositorio Alumnos Test', () {
    test('Añadir Asignatura A Alumno', () {
      //arrange
      when(() => mockProveedorAlumnos.anyadirAsignaturaAlumno(
              idAlumno: alumno.nipAlumno,
              idAsignatura: asignatura.idAsignatura))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAlumnos.anyadirAsignaturaAlumno(
          idAlumno: alumno.nipAlumno, idAsignatura: asignatura.idAsignatura);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorAlumnos.anyadirAsignaturaAlumno(
          idAlumno: alumno.nipAlumno,
          idAsignatura: asignatura.idAsignatura)).called(1);
      verifyNoMoreInteractions(mockProveedorAlumnos);
    });

    test('Añadir Asignatura A Alumno lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAlumnos.anyadirAsignaturaAlumno(
              idAlumno: alumno.nipAlumno,
              idAsignatura: asignatura.idAsignatura))
          .thenThrow(const NoSePuedeAnyadirAsignaturaAlumno());
      //act
      try {
        repositorioAlumnos.anyadirAsignaturaAlumno(
            idAlumno: alumno.nipAlumno, idAsignatura: asignatura.idAsignatura);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAlumnos.anyadirAsignaturaAlumno(
            idAlumno: alumno.nipAlumno,
            idAsignatura: asignatura.idAsignatura)).called(1);
        verifyNoMoreInteractions(mockProveedorAlumnos);
      }
    });

    test('Crear Alumno', () {
      //arrange
      when(() => mockProveedorAlumnos.crearAlumno(alumno))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAlumnos.crearAlumno(alumno);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorAlumnos.crearAlumno(alumno)).called(1);
      verifyNoMoreInteractions(mockProveedorAlumnos);
    });

    test('Crear Alumno lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAlumnos.crearAlumno(alumno))
          .thenThrow(const NoSePuedeCrearAlumno());
      //act
      try {
        repositorioAlumnos.crearAlumno(alumno);
      } on Exception catch (e) {
        //assert
        expect(e, isA<NoSePuedeCrearAlumno>());
        verify(() => mockProveedorAlumnos.crearAlumno(alumno)).called(1);
        verifyNoMoreInteractions(mockProveedorAlumnos);
      }
    });

    test('Obtener Alumnos', () async {
      //arrange

      when(() => mockProveedorAlumnos.obtenerAlumno(alumno.nipAlumno))
          .thenAnswer((_) async => alumno);
      //act
      final resultado =
          await repositorioAlumnos.obtenerAlumno(alumno.nipAlumno);
      //assert
      expect(resultado, isA<Alumno>());
      expect(resultado, equals(alumno));
      verify(() => mockProveedorAlumnos.obtenerAlumno(alumno.nipAlumno))
          .called(1);
      verifyNoMoreInteractions(mockProveedorAlumnos);
    });

    test('Obtener Alumnos lanza excepcion en caso de fallo', () async {
      //arrange
      when(() => mockProveedorAlumnos.obtenerAlumno(alumno.nipAlumno))
          .thenThrow(const NoSePuedeObtenerAlumno());
      //act
      try {
        repositorioAlumnos.obtenerAlumno(alumno.nipAlumno);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAlumnos.obtenerAlumno(alumno.nipAlumno))
            .called(1);
        verifyNoMoreInteractions(mockProveedorAlumnos);
      }
    });

    test('Eliminar Asignatura en Alumno', () {
      //arrange

      when(() => mockProveedorAlumnos.eliminarAsignatura(
              idAsignatura: asignatura.idAsignatura))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioAlumnos.eliminarAsignaturEnAlumno(
          idAsignatura: asignatura.idAsignatura);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorAlumnos.eliminarAsignatura(
          idAsignatura: asignatura.idAsignatura)).called(1);
      verifyNoMoreInteractions(mockProveedorAlumnos);
    });

    test('Eliminar Asignatura en Alumno lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorAlumnos.eliminarAsignatura(
              idAsignatura: asignatura.idAsignatura))
          .thenThrow(const NoSePuedeEliminarAsignaturaAAlumno());
      //act
      try {
        repositorioAlumnos.eliminarAsignaturEnAlumno(
            idAsignatura: asignatura.idAsignatura);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorAlumnos.eliminarAsignatura(
            idAsignatura: asignatura.idAsignatura)).called(1);
        verifyNoMoreInteractions(mockProveedorAlumnos);
      }
    });
  });
}
