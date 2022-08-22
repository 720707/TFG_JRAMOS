import 'dart:typed_data';

import '../entidades/entidades.dart';

class ArgumentosPantalla {
  final Asignatura? asignatura;
  final UsuarioAutenticado usuario;
  final Clase? clase;
  final ListaAsistenciasDia? listaAsistenciasDia;
  final ListaAsistenciasMes? listaAsistenciasMes;
  final bool? editable;
  final Asignatura? asignaturaSinEditar;
  final Uint8List? pdf;
  ArgumentosPantalla(
      {this.asignatura,
      required this.usuario,
      this.clase,
      this.listaAsistenciasDia,
      this.editable,
      this.asignaturaSinEditar,
      this.listaAsistenciasMes,
      this.pdf});
}
