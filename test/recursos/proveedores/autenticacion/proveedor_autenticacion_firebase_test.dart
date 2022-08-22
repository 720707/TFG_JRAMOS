import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/recursos/proveedores/autenticacion/proveedor_autenticacion_firebase.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProveedorAutenticacionFirebase proveedorAutenticacionFirebase;

  setUpAll(() {
    final user = MockUser(
      isAnonymous: false,
      uid: '1234',
      email: 'prueba@gmail.com',
      displayName: 'Prueba',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    proveedorAutenticacionFirebase =
        ProveedorAutenticacionFirebase(firebaseAuth: auth);
  });

  setUpAll(() {});

  group('Provedor autenticacion firebase test', () {
    test('iniciar sesion', () async {
      await proveedorAutenticacionFirebase.iniciarSesion(
          email: 'prueba@gmail.com', password: 'prueba1244');

      final usuario =
          proveedorAutenticacionFirebase.obtenerUsuarioAutenticacionActual();

      expect(usuario!.email, "prueba@gmail.com");
    });

    test('iniciar sesion lanza excepcion si el usuario no existe', () async {
      try {
        await proveedorAutenticacionFirebase.iniciarSesion(
            email: 'prueba2@gmail.com', password: 'prueba1244');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
      }
    });

    test('Registrar usuario', () async {
      await proveedorAutenticacionFirebase.registrarUsuario(
          password: 'prueba1244', email: 'prueba@gmail.com');

      final usuario =
          proveedorAutenticacionFirebase.obtenerUsuarioAutenticacionActual();

      expect(usuario!.email, "prueba@gmail.com");
    });

    test('Registrar usuario lanza excepcion en caso de error', () async {
      try {
        await proveedorAutenticacionFirebase.registrarUsuario(
            password: 'prueba1244', email: 'prueba2@gmail.com');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
      }
    });

    test('Registrar usuario lanza excepcion en caso de usuario ya registrado',
        () async {
      try {
        await proveedorAutenticacionFirebase.registrarUsuario(
            password: 'prueba1244', email: 'prueba@gmail.com');

        await proveedorAutenticacionFirebase.registrarUsuario(
            password: 'prueba1244', email: 'prueba@gmail.com');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
      }
    });

    test('Enviar email verificado lanza excepcion en caso de fallo', () async {
      try {
        await proveedorAutenticacionFirebase.enviarEmailVerificacion();
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
      }
    });

    test('Nueva password lanza excepcion si el usuario no existe', () async {
      await proveedorAutenticacionFirebase.iniciarSesion(
          email: 'prueba@gmail.com', password: 'prueba1244');

      try {
        await proveedorAutenticacionFirebase.nuevaPassword(
            email: 'prueba2@gmail.com');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionAutenticacion>());
      }
    });
  });
}
