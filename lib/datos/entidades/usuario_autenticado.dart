import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

///Autor: Javier Ramos Marco
/// * Entidad de usuario autenticado
///

@immutable
class UsuarioAutenticado extends Equatable {
  final String id;
  final String email;
  final bool emailVerificado;
  final String? nombre;

  const UsuarioAutenticado({
    required this.id,
    required this.email,
    required this.emailVerificado,
    this.nombre,
  });

  @override
  List<Object> get props => [id, email, emailVerificado];

  @override
  String toString() {
    return 'UsuarioAutenticado(id: $id, email: $email, emailVerificado: $emailVerificado, nombre: $nombre)';
  }
}
