import '../../datos/datos.dart';
import '../proveedores/asignaturas/proveedor_asignaturas.dart';

///Autor: Javier Ramos Marco
/// * Repositorio de asignaturas
///

class RepositorioAsignaturas {
  RepositorioAsignaturas({
    required ProveedorAsignaturas proveedorAsignaturas,
  }) : _proveedorAsignaturas = proveedorAsignaturas;

  final ProveedorAsignaturas _proveedorAsignaturas;

  Future<void> anyadirAsignatura(Asignatura asignatura) =>
      _proveedorAsignaturas.anyadirAsignatura(
        asignatura: asignatura,
      );

  Future<List<Asignatura>> obtenerAsignaturasUsuario(
      {required String idUsuario}) {
    return _proveedorAsignaturas.obtenerAsignaturasUsuario(
        idUsuario: idUsuario);
  }

  Future<void> actualizarListasAsistenciasMesEnAsignatura(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesSinActualizar,
      required ListaAsistenciasMes listaAsistenciasMesActualizada}) {
    return _proveedorAsignaturas.actualizarListasAsistenciasMesEnAsignatura(
        idAsignatura: idAsignatura,
        listaAsistenciasMesSinActualizar: listaAsistenciasMesSinActualizar,
        listaAsistenciasMesActualizada: listaAsistenciasMesActualizada);
  }

  Future<void> actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesActualizada}) {
    return _proveedorAsignaturas
        .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
            idAsignatura: idAsignatura,
            listaAsistenciasMesActualizada: listaAsistenciasMesActualizada);
  }

  Future<void> eliminarAsignatura({required String idAsignatura}) =>
      _proveedorAsignaturas.eliminarAsignatura(idAsignatura: idAsignatura);

  Future<void> editarListaAsistenciasDia(
          {required ListaAsistenciasMes listaAsistenciasMesSinEditar,
          required Asignatura asignatura}) =>
      _proveedorAsignaturas.editarListaAsistenciasDia(
          listaAsistenciasMesSinEditar: listaAsistenciasMesSinEditar,
          asignatura: asignatura);
}
