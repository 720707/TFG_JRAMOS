part of 'autenticacion_bloc.dart';

///Autor: Javier Ramos Marco
/// * Eventos del bloc AutenticacionBloc
///

@immutable
abstract class EventoAutenticacion extends Equatable {
  const EventoAutenticacion();
}

//Evento para comprobar el estado en el que esta el usuario (si ha iniciado sesion
//si no ha iniciado sesion)
@immutable
class ComprobarEstadoUsuario extends EventoAutenticacion {
  const ComprobarEstadoUsuario();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando el usuario pulsa el boton de iniciar sesion
@immutable
class IniciarSesion extends EventoAutenticacion {
  final String correo;
  final String password;

  const IniciarSesion({required this.correo, required this.password});
  @override
  List<Object> get props => [correo, password];
}

//Evento que se produce cuando el usuario pulsa el boton para enviar email
//de verificacion
@immutable
class EviarEmailVerificacion extends EventoAutenticacion {
  const EviarEmailVerificacion();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando el usuario pulsa el boton de registrar
@immutable
class RegistrarUsuario extends EventoAutenticacion {
  final String correo;
  final String password;
  const RegistrarUsuario({required this.correo, required this.password});
  @override
  List<Object> get props => [correo, password];
}

//Evento que se produce cuando el usuario pulsa el boton de iniciar sesion con Google
@immutable
class IniciarSesionConGoogle extends EventoAutenticacion {
  const IniciarSesionConGoogle();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando el usuario pulsa el boton de cerrar sesion
@immutable
class CerrarSesion extends EventoAutenticacion {
  const CerrarSesion();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando el usuario pulsa el boton de cerrar sesion
@immutable
class EventoIrAConfirmarEmail extends EventoAutenticacion {
  const EventoIrAConfirmarEmail();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando el usuario pulsa el boton de eliminar la cuenta
class EliminarCuenta extends EventoAutenticacion {
  const EliminarCuenta();
  @override
  List<Object> get props => [];
}

class NuevaPassword extends EventoAutenticacion {
  final String correo;
  const NuevaPassword({required this.correo});
  @override
  List<Object> get props => [correo];
}

class ObtenerUsuario extends EventoAutenticacion {
  const ObtenerUsuario();
  @override
  List<Object> get props => [DateTime.now()];
}
