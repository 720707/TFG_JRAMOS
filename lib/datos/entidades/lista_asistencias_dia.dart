import 'package:equatable/equatable.dart';

import '../datos.dart';

///Autor: Javier Ramos Marco
/// * Entidad de lista asistencias dia
///

class ListaAsistenciasDia extends Equatable {
  //id: idAsignatura + dia + mes + año
  final String idListaAsistenciasDia;

  final DateTime fecha;
  final String idAsignatura;
  final List<Alumno> alumnos;

  const ListaAsistenciasDia({
    required this.idListaAsistenciasDia,
    required this.idAsignatura,
    required this.alumnos,
    required this.fecha,
  });

  @override
  List<Object?> get props => [
        idListaAsistenciasDia,
        idAsignatura,
        fecha,
        alumnos,
      ];

  @override
  String toString() {
    return 'ListaAsistenciasDiaEntidad(idListaAsistenciasDia: $idListaAsistenciasDia, fecha: $fecha, idAsignatura: $idAsignatura, alumnos: $alumnos)';
  }
}
