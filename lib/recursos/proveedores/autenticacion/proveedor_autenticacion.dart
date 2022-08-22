import '../../../datos/entidades/usuario_autenticado.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de autenticacion
///

abstract class ProveedorAutenticacion {
  const ProveedorAutenticacion();

  /// Método para iniciar sesion mediante email y contraseña
  Future<void> iniciarSesion({
    required String email,
    required String password,
  });

  //Funcion para registrar un nuevo usuario
  Future<void> registrarUsuario({
    required String email,
    required String password,
  });

  //Funcion para cerrar sesion del usuario
  Future<void> cerrarSesion();

  //Método para iniciar sesión mediante Google
  Future<void> iniciarSesionConGoogle();

  //Método para enviar un email de verificacion a un usuario
  Future<void> enviarEmailVerificacion();

  Future<void> eliminarCuenta();

  UsuarioAutenticado? obtenerUsuarioAutenticacionActual();

  Future<void> nuevaPassword({required String email});
}
