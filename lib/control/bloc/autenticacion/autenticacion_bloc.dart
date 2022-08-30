import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../configuracion/configuracion.dart';
import '../../../recursos/repositorios/repositorio_autenticacion.dart';
import '../../excepciones/autenticacion/excepciones_autenticacion.dart';
import 'autenticacion_state.dart';

part 'autenticacion_event.dart';

///Autor: Javier Ramos Marco
/// * Bloc para controlar los eventos relacionados con la autenticacion
///

class AutenticacionBloc extends Bloc<EventoAutenticacion, EstadoAutenticacion> {
  final RepositorioAutenticacion _repositorioAutenticacion;
  //El usuario al principio no esta autenticado
  AutenticacionBloc(
      {required RepositorioAutenticacion repositorioAutenticacion})
      : _repositorioAutenticacion = repositorioAutenticacion,
        super(const NoAutenticado()) {
    //Cuando el usuario pulsa el boton de Iniciar sesion se manda un evento a Bloc
    on<IniciarSesion>((event, emit) async {
      emit(const EstadoCargando());
      try {
        await _repositorioAutenticacion.iniciarSesion(
            email: event.correo, password: event.password);
        final usuario = repositorioAutenticacion.usuarioActual;
        emit(SesionIniciada(usuario!));

        final user = _repositorioAutenticacion.usuarioActual;

        if (user!.emailVerificado != true) {
          emit(const SinVerificarCorreo());
        }
      } on Exception catch (e) {
        if (e is UsuarioAutenticadoNoEncontrado) {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoUsuarioNoEncontrado));
        } else if (e is PasswordIncorrecta) {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoPasswordIncorrecta));
        } else {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoExcepcionGenerica));
        }
      }
    });

    //Se recibe el evento para comprobar si hay ya un usuario autenticado
    on<ComprobarEstadoUsuario>((event, emit) async {
      emit(const EstadoCargando());
      final usuario = _repositorioAutenticacion.usuarioActual;

      //Si no hay usuario, significa que no se ha iniciado sesion
      if (usuario == null) {
        emit(const NoAutenticado());
      } else if (!usuario.emailVerificado) {
        emit(const SinVerificarCorreo());
      } else {
        emit(
          SesionIniciada(usuario),
        );
      }
    });

    on<IniciarSesionConGoogle>((event, emit) async {
      emit(const EstadoCargando());
      try {
        await _repositorioAutenticacion.iniciarSesionConGoogle();
        final usuario = _repositorioAutenticacion.usuarioActual;
        emit(SesionIniciada(usuario!));
      } on Exception catch (e) {
        emit(ErrorAutenticacion(excepcion: e, mensaje: textoExcepcionGenerica));
      }
    });

    on<NuevaPassword>(((event, emit) async {
      emit(const EstadoCargando());
      try {
        await _repositorioAutenticacion.nuevaPassword(email: event.correo);
        emit(const CorreoEnviado());
      } on Exception catch (e) {
        if (e is UsuarioAutenticadoNoEncontrado) {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoUsuarioNoEncontrado));
        } else if (e is EmailInvalido) {
          emit(ErrorAutenticacion(excepcion: e, mensaje: textoEmailInvalido));
        } else {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoExcepcionGenerica));
        }
      }
    }));

    on<EviarEmailVerificacion>((event, emit) async {
      emit(const EstadoCargando());
      await _repositorioAutenticacion.enviarEmailVerificacion();
    });

    on<RegistrarUsuario>((event, emit) async {
      emit(const EstadoCargando());

      final email = event.correo;
      final password = event.password;

      try {
        await _repositorioAutenticacion.registrarUsuario(
          email: email,
          password: password,
        );
        await _repositorioAutenticacion.enviarEmailVerificacion();
        emit(const SinVerificarCorreo());
      } on Exception catch (e) {
        if (e is EmailEnUso) {
          emit(ErrorAutenticacion(excepcion: e, mensaje: textoEmailEnUso));
        } else if (e is EmailInvalido) {
          emit(ErrorAutenticacion(excepcion: e, mensaje: textoEmailInvalido));
        } else {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoExcepcionGenerica));
        }
      }
    });

    on<CerrarSesion>((state, emit) async {
      emit(const EstadoCargando());
      await _repositorioAutenticacion.cerrarSesion();
      emit(const NoAutenticado());
    });

    on<EliminarCuenta>((state, emit) async {
      emit(const EstadoCargando());
      try {
        await _repositorioAutenticacion.eliminarCuenta();
        emit(const NoAutenticado());
      } on Exception catch (e) {
        if (e is UsuarioAutenticadoNoHaIniciadoSesion) {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoExcepcionGenerica));
        } else {
          emit(ErrorAutenticacion(
              excepcion: e, mensaje: textoExcepcionGenerica));
        }
        emit(const NoAutenticado());
      }
    });

    on<ObtenerUsuario>((state, emit) async {
      final usuario = _repositorioAutenticacion.usuarioActual;
      if (usuario != null) {
        emit(UsuarioObtenido(usuario: usuario));
      }
    });
  }
}
