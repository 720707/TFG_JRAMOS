import '../../datos/datos.dart';
import '../proveedores/alumnos/proveedor_alumnos.dart';

///Autor: Javier Ramos Marco
/// * Repositorio de alumnos
///

class RepositorioAlumnos {
  RepositorioAlumnos({
    required ProveedorAlumnos proveedorAlumnos,
  }) : _proveedorAlumnos = proveedorAlumnos;

  final ProveedorAlumnos _proveedorAlumnos;

  Future<void> crearAlumno(
    Alumno alumno,
  ) =>
      _proveedorAlumnos.crearAlumno(alumno);

  Future<Alumno> obtenerAlumno(String nipAlumno) {
    final alumno = _proveedorAlumnos.obtenerAlumno(nipAlumno);
    return alumno;
  }

  Future<void> anyadirAsignaturaAAlumno(
          {required String idAlumno, required String idAsignatura}) =>
      _proveedorAlumnos.anyadirAsignaturaAAlumno(
          idAlumno: idAlumno, idAsignatura: idAsignatura);

  Future<void> eliminarAsignaturEnAlumno({required String idAsignatura}) =>
      _proveedorAlumnos.eliminarAsignatura(idAsignatura: idAsignatura);
}
