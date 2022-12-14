import 'package:equatable/equatable.dart';

import '../datos.dart';

///Autor: Javier Ramos Marco
/// * Entidad de clase
///

//Clase que representa un evento de clase en el calendario
class Clase extends Equatable {

  final String idClase;
  final String idAsignatura;
  final String idProfesor;
  final String nombreAsignatura;
  final DateTime diaClase;
  final String nombreGrado;
  final List<Alumno> alumnos;
  bool listaPasada;

  Clase({
    required this.idClase,
    required this.idAsignatura,
    required this.idProfesor,
    required this.nombreAsignatura,
    required this.diaClase,
    required this.nombreGrado,
    required this.alumnos,
    required this.listaPasada,
  });

  @override
  List<Object?> get props => [
        idAsignatura,
        diaClase,
        nombreGrado,
        idProfesor,
        nombreAsignatura,
        listaPasada
      ];

  @override
  String toString() {
    return 'ClaseEntidad(idClase: $idClase, idAsignatura: $idAsignatura, idProfesor: $idProfesor, nombreAsignatura: $nombreAsignatura, diaClase: $diaClase, nombreGrado: $nombreGrado, alumnos: $alumnos, listaPasada: $listaPasada)';
  }
}
