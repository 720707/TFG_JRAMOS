import 'package:equatable/equatable.dart';

import 'lista_asistencias_mes.dart';

///Autor: Javier Ramos Marco
/// * Entidad de alumno
///

class Asignatura extends Equatable {
  //Id de referencia a el documento de Firestore (puede ser el nombre
  //de la asignautrua + fecha inicio + idProfesor)
  final String idAsignatura;
  //Este es el id del usuario que lo crea (user.uid)
  final String idProfesor;
  final String nombreAsignatura;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<String> dias;
  final String nombreGrado;
  final List<String> idAlumnos;
  final List<ListaAsistenciasMes> listasAsistenciasMes;

  const Asignatura({
    required this.idAsignatura,
    required this.idProfesor,
    required this.nombreAsignatura,
    required this.fechaInicio,
    required this.fechaFin,
    required this.dias,
    required this.nombreGrado,
    required this.idAlumnos,
    required this.listasAsistenciasMes,
  });

  @override
  List<Object?> get props =>
      [idAsignatura, fechaFin, fechaInicio, nombreGrado, idProfesor];

  @override
  String toString() {
    return 'AsignaturaEntidad(idAsignatura: $idAsignatura, idProfesor: $idProfesor, nombreAsignatura: $nombreAsignatura, fechaInicio: $fechaInicio, fechaFin: $fechaFin, dias: $dias, nombreGrado: $nombreGrado, idAlumnos: $idAlumnos, listasAsistenciasMes: $listasAsistenciasMes)';
  }
}
