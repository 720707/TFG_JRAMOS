import 'dart:developer';

import '../../recursos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../control/excepciones/excepciones.dart';
import '../../../datos/entidades/usuario_autenticado.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de autenticacion en firebase
///

class ProveedorAutenticacionFirebase implements ProveedorAutenticacion {
  final FirebaseAuth firebaseAuth;

  ProveedorAutenticacionFirebase({required this.firebaseAuth});

  /// Método para iniciar sesion mediante email y contraseña
  @override
  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UsuarioAutenticadoNoEncontrado();
      } else if (e.code == 'wrong-password') {
        throw const PasswordIncorrecta();
      } //Otros errores diferente en relacion a Firebase
      else {
        throw const ExcepcionGenerica();
      }
    }
    //Para excepciones que no son de FirebaseAuth como problemas de conexion
    catch (e) {
      throw const ExcepcionGenerica();
    }
  }

  //Funcion para registrar un nuevo usuario
  @override
  Future<void> registrarUsuario({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const EmailEnUso();
      } else if (e.code == 'invalid-email') {
        throw const EmailInvalido();
      } else {
        throw const ExcepcionGenerica();
      }
    } catch (_) {
      throw const ExcepcionGenerica();
    }
  }

  //Funcion para cerrar sesion del usuario
  @override
  Future<void> cerrarSesion() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } else {
      throw const UsuarioAutenticadoNoHaIniciadoSesion();
    }
  }

  //Método para iniciar sesión mediante Google
  @override
  Future<void> iniciarSesionConGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      //Obtenemos las credenciales
      final credenciales = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await firebaseAuth.signInWithCredential(credenciales);
    } catch (_) {
      throw const ExcepcionGenerica();
    }
  }

  //Método para enviar un email de verificacion a un usuario
  @override
  Future<void> enviarEmailVerificacion() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw const UsuarioAutenticadoNoHaIniciadoSesion();
    }
  }

  @override
  UsuarioAutenticado? obtenerUsuarioAutenticacionActual() {
    final usuario = firebaseAuth.currentUser;
    log(usuario.toString());
    if (usuario != null) {
      return UsuarioAutenticadoDTO.deFirebase(usuario).toEntity();
    } else {
      return null;
    }
  }

  @override
  Future<void> eliminarCuenta() async {
    final usuario = firebaseAuth.currentUser;

    if (usuario != null) {
      try {
        await usuario.delete();
        await GoogleSignIn().signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          throw const UsuarioAutenticadoNoHaIniciadoSesion();
        }
      } on Exception {
        throw const ExcepcionGenerica();
      }
    }
  }

  @override
  Future<void> nuevaPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UsuarioAutenticadoNoEncontrado();
      } else if (e.code == 'invalid-email') {
        throw const EmailInvalido();
      }
    } on Exception {
      throw const ExcepcionGenerica();
    }
  }
}
