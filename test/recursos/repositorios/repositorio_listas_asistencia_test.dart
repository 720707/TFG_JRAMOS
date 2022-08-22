import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/entidades.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockProveedorListasAsistencia mockProveedorListasAsistencia;
  late RepositorioListasAsistencia repositorioListasAsistencia;
  late Asignatura asignatura;
  late List<ListaAsistenciasMes> listasAsistenciasMes;
  late ListaAsistenciasMes listaAsistenciasMes;
  late ListaAsistenciasDia listaAsistenciasDia;

  setUpAll(() {
    mockProveedorListasAsistencia = MockProveedorListasAsistencia();
    repositorioListasAsistencia = RepositorioListasAsistencia(
        proveedorListasAsistencia: mockProveedorListasAsistencia);
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
    listasAsistenciasMes = List.generate(
        5,
        (index) => const ListaAsistenciasMes(
            idListaAsistenciasMes: '434',
            mes: 12,
            anyo: 2022,
            idAsignatura: 'idAsignatura',
            listaAsistenciasDia: []));
    listaAsistenciasMes = const ListaAsistenciasMes(
        anyo: 2022,
        listaAsistenciasDia: [],
        idAsignatura: '',
        idListaAsistenciasMes: '',
        mes: 3);
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
    listaAsistenciasDia = ListaAsistenciasDia(
        alumnos: const [],
        fecha: DateTime.now(),
        idAsignatura: '',
        idListaAsistenciasDia: '');
  });

  group('Repositorio Listas Asistencia Test', () {
    test('Pasar Lista Asistencias Dia', () {
      //arrange
      when(() => mockProveedorListasAsistencia.pasarListaAsistenciasDia(
          listaAsistenciasDia)).thenAnswer((_) async => Future<void>.value);
      //act
      final resultado = repositorioListasAsistencia
          .pasarListaAsistenciasDia(listaAsistenciasDia);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorListasAsistencia
          .pasarListaAsistenciasDia(listaAsistenciasDia)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Pasar Lista Asistencias Dia lanza excepcion en caso de fallo', () {
      //arrange
      when(() => mockProveedorListasAsistencia
              .pasarListaAsistenciasDia(listaAsistenciasDia))
          .thenThrow(const NoSePuedeCrearListaAsistenciaDia());
      //act
      try {
        repositorioListasAsistencia
            .pasarListaAsistenciasDia(listaAsistenciasDia);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorListasAsistencia
            .pasarListaAsistenciasDia(listaAsistenciasDia)).called(1);
        verifyNoMoreInteractions(mockProveedorListasAsistencia);
      }
    });

    test('Actualizar Lista Asistencias Mes', () {
      //arrange

      when(() => mockProveedorListasAsistencia.actualizarListaAsistenciasMes(
              listaAistenciasMes: listaAsistenciasMes,
              listaAsistenciasDia: listaAsistenciasDia))
          .thenAnswer((_) async => Future<void>.value);
      //act
      final resultado =
          repositorioListasAsistencia.actualizarListaAsistenciasMes(
              listaAsistenciasMes: listaAsistenciasMes,
              listaAsistenciasDia: listaAsistenciasDia);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorListasAsistencia.actualizarListaAsistenciasMes(
          listaAistenciasMes: listaAsistenciasMes,
          listaAsistenciasDia: listaAsistenciasDia)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Actualizar Lista Asistencias Mes lanza excepcion en caso de fallo',
        () {
      //arrange
      when(() => mockProveedorListasAsistencia.actualizarListaAsistenciasMes(
              listaAistenciasMes: listaAsistenciasMes,
              listaAsistenciasDia: listaAsistenciasDia))
          .thenThrow(const ExcepcionNoSePuedeAnyadirListaAsistenciaMes());
      //act
      try {
        repositorioListasAsistencia.actualizarListaAsistenciasMes(
            listaAsistenciasMes: listaAsistenciasMes,
            listaAsistenciasDia: listaAsistenciasDia);
      } on Exception catch (e) {
        //assert
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() =>
            mockProveedorListasAsistencia.actualizarListaAsistenciasMes(
                listaAistenciasMes: listaAsistenciasMes,
                listaAsistenciasDia: listaAsistenciasDia)).called(1);
        verifyNoMoreInteractions(mockProveedorListasAsistencia);
      }
    });

    test('Obtener Listas Asistencias Mes Concreta', () async {
      //arrange
      when(() => mockProveedorListasAsistencia.obtenerListasAsistenciasMes(
          idAsignatura: asignatura.idAsignatura,
          anyo: 2022,
          mes: 8)).thenAnswer((_) async => listasAsistenciasMes);
      //act
      final resultado =
          await repositorioListasAsistencia.obtenerListaAsistenciasMes(
              idAsignatura: asignatura.idAsignatura, anyo: 2022, mes: 8);
      //assert
      expect(resultado, isA<List<ListaAsistenciasMes>>());
      expect(resultado, equals(listasAsistenciasMes));
      verify(() => mockProveedorListasAsistencia.obtenerListasAsistenciasMes(
          idAsignatura: asignatura.idAsignatura, anyo: 2022, mes: 8)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Eliminar Listas Asistencias', () async {
      //arrange
      when(() => mockProveedorListasAsistencia.eliminarListasAsistencias(
            idAsignatura: asignatura.idAsignatura,
          )).thenAnswer((_) async => listasAsistenciasMes);
      //act
      final resultado = repositorioListasAsistencia.eliminarListasAsistencia(
          idAsignatura: asignatura.idAsignatura);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorListasAsistencia.eliminarListasAsistencias(
          idAsignatura: asignatura.idAsignatura)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Eliminar Lista Asistencias Dia Concreto', () async {
      //arrange
      when(() => mockProveedorListasAsistencia.eliminarListasAsistencias(
            idAsignatura: asignatura.idAsignatura,
          )).thenAnswer((_) async => listasAsistenciasMes);
      //act
      final resultado = repositorioListasAsistencia.eliminarListasAsistencia(
          idAsignatura: asignatura.idAsignatura);
      //assert
      expect(resultado, isA<Future<void>>());

      verify(() => mockProveedorListasAsistencia.eliminarListasAsistencias(
          idAsignatura: asignatura.idAsignatura)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Editar Lista Asistencia Dia', () async {
      //arrange
      when(() => mockProveedorListasAsistencia.editarListaAsistenciasDia(
              listaAsistenciasDia: listaAsistenciasDia))
          .thenAnswer((_) async => listaAsistenciasMes);
      //act
      final resultado = await repositorioListasAsistencia
          .editarListaAsistenciaDia(listaAsistencias: listaAsistenciasDia);
      //assert
      expect(resultado, isA<ListaAsistenciasMes>());
      expect(resultado, equals(listaAsistenciasMes));
      verify(() => mockProveedorListasAsistencia.editarListaAsistenciasDia(
          listaAsistenciasDia: listaAsistenciasDia)).called(1);
      verifyNoMoreInteractions(mockProveedorListasAsistencia);
    });

    test('Editar Lista Asistencia Dia lanza una excepcion cuando falla',
        () async {
      //arrange
      when(() => mockProveedorListasAsistencia.editarListaAsistenciasDia(
              listaAsistenciasDia: listaAsistenciasDia))
          .thenThrow(const ExcepcionNoSePuedeEditarListaAsistenciaDia());
      //act
      try {
        await repositorioListasAsistencia.editarListaAsistenciaDia(
            listaAsistencias: listaAsistenciasDia);
      } on Exception catch (e) {
        expect(e, isA<ExcepcionBaseDeDatos>());
        verify(() => mockProveedorListasAsistencia.editarListaAsistenciasDia(
            listaAsistenciasDia: listaAsistenciasDia)).called(1);
        verifyNoMoreInteractions(mockProveedorListasAsistencia);
      }
    });
  });
}
