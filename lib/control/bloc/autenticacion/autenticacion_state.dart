import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../datos/entidades/usuario_autenticado.dart';

///Autor: Javier Ramos Marco
/// * Estados del bloc AutenticacionBloc
///

@immutable
abstract class EstadoAutenticacion extends Equatable {
  const EstadoAutenticacion();
}

//Estado que se produce cuando se esta haciendo alguna operacion
@immutable
class EstadoCargando extends EstadoAutenticacion {
  final String? texto;
  const EstadoCargando({
    this.texto = 'Espera un momento',
  });
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando el usuario esta iniciando sesion
@immutable
class SesionIniciada extends EstadoAutenticacion {
  final UsuarioAutenticado usuarioAutenticado;
  const SesionIniciada(this.usuarioAutenticado);
  @override
  List<Object?> get props => [];
}

@immutable
class UsuarioRegistrado extends EstadoAutenticacion {
  const UsuarioRegistrado();
  @override
  List<Object?> get props => [];
}

//Cuando el usuario no tiene el correo verificado
@immutable
class SinVerificarCorreo extends EstadoAutenticacion {
  const SinVerificarCorreo();
  @override
  List<Object?> get props => [];
}

//Cuando el usuario cierra sesion
@immutable
class SesionCerrada extends EstadoAutenticacion {
  const SesionCerrada();
  @override
  List<Object?> get props => [];
}

//Estado inicial cuando el usuario aun no esta autenticado
@immutable
class NoAutenticado extends EstadoAutenticacion {
  const NoAutenticado();
  @override
  List<Object?> get props => [];
}

//En caso de que ocurra algun error a la hora de autenticar
//Distingimos entre erroes genericos y errores de autenticacion (de firebaseAuthException)
@immutable
class ErrorAutenticacion extends EstadoAutenticacion {
  final Exception excepcion;
  final String mensaje;
  const ErrorAutenticacion({required this.excepcion, required this.mensaje});
  @override
  List<Object?> get props => [excepcion, mensaje];
}

class UsuarioObtenido extends EstadoAutenticacion {
  final UsuarioAutenticado usuario;
  const UsuarioObtenido({
    required this.usuario,
  });
  @override
  List<Object> get props => [];
}

class CorreoEnviado extends EstadoAutenticacion {
  const CorreoEnviado();
  @override
  List<Object?> get props => [];
}
