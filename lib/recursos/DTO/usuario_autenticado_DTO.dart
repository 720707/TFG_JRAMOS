import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../datos/entidades/usuario_autenticado.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar UsuarioAutenticado con la interfaz y los repositorios
///

@immutable
class UsuarioAutenticadoDTO extends UsuarioAutenticado {
  const UsuarioAutenticadoDTO({
    required String id,
    required String email,
    required bool emailVerificado,
    String? nombre,
  }) : super(
          id: id,
          email: email,
          emailVerificado: emailVerificado,
          nombre: nombre,
        );

  factory UsuarioAutenticadoDTO.deFirebase(User usuario) =>
      UsuarioAutenticadoDTO(
        id: usuario.uid,
        email: usuario.email!,
        emailVerificado: usuario.emailVerified,
        nombre: usuario.displayName ?? '',
      );

  UsuarioAutenticado toEntity() {
    return UsuarioAutenticado(
        id: id,
        email: email,
        emailVerificado: emailVerificado,
        nombre: nombre ?? '');
  }

  factory UsuarioAutenticadoDTO.fromEntity(UsuarioAutenticado entidad) {
    return UsuarioAutenticadoDTO(
        id: entidad.id,
        email: entidad.email,
        emailVerificado: entidad.emailVerificado,
        nombre: entidad.nombre);
  }

  @override
  List<Object> get props => [id, email, emailVerificado];
}
