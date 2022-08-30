import '../../datos/entidades/usuario_autenticado.dart';

import '../proveedores/autenticacion/proveedor_autenticacion.dart';

///Autor: Javier Ramos Marco
/// * Repositorio de autenticacion
///

class RepositorioAutenticacion {
  //Obtenemos el proovedor de autenticacion

  RepositorioAutenticacion({
    required ProveedorAutenticacion proveedorAutenticacion,
  }) : _proveedorAutenticacion = proveedorAutenticacion;

  final ProveedorAutenticacion _proveedorAutenticacion;

  /// Método para iniciar sesion mediante email y contraseña
  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) =>
      _proveedorAutenticacion.iniciarSesion(
        email: email,
        password: password,
      );

  //Funcion para registrar un nuevo usuario
  Future<void> registrarUsuario({
    required String email,
    required String password,
  }) =>
      _proveedorAutenticacion.registrarUsuario(
        email: email,
        password: password,
      );

  //Funcion para cerrar la sesion del usuario
  Future<void> cerrarSesion() => _proveedorAutenticacion.cerrarSesion();

  //Método para iniciar sesión mediante Google
  Future<void> iniciarSesionConGoogle() async {
    await _proveedorAutenticacion.iniciarSesionConGoogle();
  }

  //Método para enviar un email de verificacion a un usuario
  Future<void> enviarEmailVerificacion() =>
      _proveedorAutenticacion.enviarEmailVerificacion();

  UsuarioAutenticado? get usuarioActual {
    final usuario = _proveedorAutenticacion.obtenerUsuarioAutenticacionActual();
    if (usuario == null) {
      return null;
    }
    return usuario;
  }

  Future<void> eliminarCuenta() => _proveedorAutenticacion.eliminarCuenta();

  //Método para obtener una nueva contraseña
  Future<void> nuevaPassword({required String email}) =>
      _proveedorAutenticacion.nuevaPassword(email: email);
}
