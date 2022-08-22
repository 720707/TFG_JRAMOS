import 'package:equatable/equatable.dart';

import 'lista_asistencias_dia.dart';

///Autor: Javier Ramos Marco
/// * Entidad de lista asistencias mes
///

class ListaAsistenciasMes extends Equatable {
  //id: idAsignatura + mes + año
  final String idListaAsistenciasMes;
  final int mes;
  final int anyo;
  final String idAsignatura;
  final List<ListaAsistenciasDia> listaAsistenciasDia;

  const ListaAsistenciasMes({
    required this.idListaAsistenciasMes,
    required this.mes,
    required this.anyo,
    required this.idAsignatura,
    required this.listaAsistenciasDia,
  });

  @override
  List<Object?> get props =>
      [listaAsistenciasDia, idListaAsistenciasMes, idAsignatura, mes, anyo];

  @override
  String toString() {
    return 'ListaAsistenciasMes(idListaAsistenciasMes: $idListaAsistenciasMes, mes: $mes, anyo: $anyo, idAsignatura: $idAsignatura, listaAsistenciasDia: $listaAsistenciasDia)';
  }
}
