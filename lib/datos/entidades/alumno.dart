import 'package:equatable/equatable.dart';

///Autor: Javier Ramos Marco
/// * Entidad de alumno
///
class Alumno extends Equatable {
  final String nipAlumno;
  final String dniAlumno;
  final String nombreCompleto;
  //Asignatura y listaAsistenciaMes tendran que ser de tipo String y pasar el
  //id del documento al que hacen referencia
  final List<String>? asignaturas;
  bool presente;

  Alumno(
      {required this.nipAlumno,
      required this.nombreCompleto,
      required this.dniAlumno,
      this.asignaturas,
      required this.presente});

  @override
  List<Object?> get props => [nipAlumno, dniAlumno];

  @override
  String toString() {
    return 'AlumnoEntidad(nipAlumno: $nipAlumno, dniAlumno: $dniAlumno, nombreCompleto: $nombreCompleto, asignaturas: $asignaturas, presente: $presente)';
  }
}
