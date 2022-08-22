import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/usuario_autenticado.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';
import '../../utils/parametros.dart';

void main() {
  late MockProveedorAutenticacion mockProveedorAutenticacion;
  late RepositorioAutenticacion repositorioAutenticacion;

  setUpAll(() {
    mockProveedorAutenticacion = MockProveedorAutenticacion();
    repositorioAutenticacion = RepositorioAutenticacion(
        proveedorAutenticacion: mockProveedorAutenticacion);
  });

  group('Repositorio autenticacion', () {
    test('Iniciar sesion', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      const String password = '1234';
      when(() => mockProveedorAutenticacion.iniciarSesion(
          email: email,
          password: password)).thenAnswer((_) async => Future<void>.value);

      //act
      final resultado = repositorioAutenticacion.iniciarSesion(
          email: email, password: password);

      //expect
      expect(resultado, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.iniciarSesion(
          email: email, password: password)).called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Iniciar sesion lanza excepcion en caso de fallo', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      const String password = '1234';
      when(() => mockProveedorAutenticacion.iniciarSesion(
          email: email,
          password: password)).thenThrow(const ExcepcionGenerica());
      //act
      try {
        repositorioAutenticacion.iniciarSesion(
            email: email, password: password);
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.iniciarSesion(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });

    test('Registar usuario', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      const String password = '1234';
      when(() => mockProveedorAutenticacion.registrarUsuario(
          email: email,
          password: password)).thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.registrarUsuario(
          email: email, password: password);

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.registrarUsuario(
          email: email, password: password)).called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Registar usuario lanza excepcion en caso de fallo', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      const String password = '1234';
      when(() => mockProveedorAutenticacion.registrarUsuario(
          email: email, password: password)).thenThrow(const EmailInvalido());

      //act
      try {
        repositorioAutenticacion.registrarUsuario(
            email: email, password: password);
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.registrarUsuario(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });

    test('Cerrar sesion', () async {
      //arrange
      when(() => mockProveedorAutenticacion.cerrarSesion())
          .thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.cerrarSesion();

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.cerrarSesion()).called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Cerrar sesion lanza excepcion en caso de fallo', () async {
      //arrange
      when(() => mockProveedorAutenticacion.cerrarSesion())
          .thenThrow(const ExcepcionGenerica());
      //act
      try {
        repositorioAutenticacion.cerrarSesion();
      } on Exception catch (e) {
        //expect
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.cerrarSesion()).called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });

    test('Iniciar Sesion con Google', () async {
      //arrange
      when(() => mockProveedorAutenticacion.iniciarSesionConGoogle())
          .thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.iniciarSesionConGoogle();

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.iniciarSesionConGoogle())
          .called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    //Falla
    test('Iniciar Sesion con Google lanza una excepcion en caso de fallo',
        () async {
      //arrange
      when(() => mockProveedorAutenticacion.iniciarSesionConGoogle())
          .thenThrow(const ExcepcionGenerica());
      //act
      try {
        await repositorioAutenticacion.iniciarSesionConGoogle();
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.iniciarSesionConGoogle())
            .called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });

    test('Enviar emial verificacion', () async {
      //arrange
      when(() => mockProveedorAutenticacion.enviarEmailVerificacion())
          .thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.enviarEmailVerificacion();

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.enviarEmailVerificacion())
          .called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Enviar emial verificacion lanza excepcion en caso de error',
        () async {
      //arrange
      when(() => mockProveedorAutenticacion.enviarEmailVerificacion())
          .thenThrow(const UsuarioAutenticadoNoHaIniciadoSesion());

      //act
      try {
        repositorioAutenticacion.enviarEmailVerificacion();
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.enviarEmailVerificacion())
            .called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }

      //expect
    });

    test('Obtener Usuario', () async {
      //arrange

      when(() => mockProveedorAutenticacion.obtenerUsuarioAutenticacionActual())
          .thenAnswer((_) => usuario);

      //act
      final resultado = repositorioAutenticacion.usuarioActual;

      //expect
      expect(resultado, isA<UsuarioAutenticado>());
      expect(resultado, equals(usuario));
      verify(() =>
              mockProveedorAutenticacion.obtenerUsuarioAutenticacionActual())
          .called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Eliminar Cuenta', () async {
      //arrange
      when(() => mockProveedorAutenticacion.eliminarCuenta())
          .thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.eliminarCuenta();

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.eliminarCuenta()).called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Eliminar Cuenta lanza una excepcion en caso de fallo', () async {
      //arrange
      when(() => mockProveedorAutenticacion.eliminarCuenta())
          .thenThrow(const UsuarioAutenticadoNoHaIniciadoSesion());

      //act
      try {
        repositorioAutenticacion.eliminarCuenta();
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.eliminarCuenta()).called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });

    test('Nueva Password', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      when(() => mockProveedorAutenticacion.nuevaPassword(email: email))
          .thenAnswer((_) async => Future<void>.value);

      //act
      final result = repositorioAutenticacion.borrarCuenta(email: email);

      //expect
      expect(result, isA<Future<void>>());
      verify(() => mockProveedorAutenticacion.nuevaPassword(email: email))
          .called(1);
      verifyNoMoreInteractions(mockProveedorAutenticacion);
    });

    test('Nueva Password lanza una excepcion en caso de fallo', () async {
      //arrange
      const String email = 'prueba@gmail.com';
      when(() => mockProveedorAutenticacion.nuevaPassword(email: email))
          .thenThrow(const EmailInvalido());
      //act
      try {
        repositorioAutenticacion.borrarCuenta(email: email);
      } on Exception catch (e) {
        //expect
        expect(e, isA<ExcepcionAutenticacion>());
        verify(() => mockProveedorAutenticacion.nuevaPassword(email: email))
            .called(1);
        verifyNoMoreInteractions(mockProveedorAutenticacion);
      }
    });
  });
}
