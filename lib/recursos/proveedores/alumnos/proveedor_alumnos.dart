import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de listas de alumnos
///

abstract class ProveedorAlumnos {
  Future<void> anyadirAsignaturaAAlumno(
      {required String idAlumno, required String idAsignatura});

  Future<void> crearAlumno(Alumno alumno);

  Future<Alumno> obtenerAlumno(String nipAlumno);

  Future<void> eliminarAsignatura({required String idAsignatura});
}
