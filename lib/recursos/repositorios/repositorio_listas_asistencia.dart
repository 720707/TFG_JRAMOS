import '../../datos/datos.dart';
import '../proveedores/listas_asistencia/proveedor_listas_asistencia.dart';

///Autor: Javier Ramos Marco
/// * Repositorio de listas de asistencia
///

class RepositorioListasAsistencia {
  RepositorioListasAsistencia({
    required ProveedorListasAsistencia proveedorListasAsistencia,
  }) : _proveedorListasAsistencia = proveedorListasAsistencia;

  final ProveedorListasAsistencia _proveedorListasAsistencia;

  Future<void> pasarListaAsistenciasDia(
    ListaAsistenciasDia listaAistenciasDia,
  ) =>
      _proveedorListasAsistencia.pasarListaAsistenciasDia(listaAistenciasDia);

  Future<void> actualizarListaAsistenciasMes(
          {required ListaAsistenciasDia listaAsistenciasDia,
          required ListaAsistenciasMes listaAsistenciasMes}) =>
      _proveedorListasAsistencia.actualizarListaAsistenciasMes(
          listaAsistenciasDia: listaAsistenciasDia,
          listaAistenciasMes: listaAsistenciasMes);

  //Metodo para obtener una lista de asistencia mes concreta
  Future<List<ListaAsistenciasMes>> obtenerListaAsistenciasMes(
          {required String idAsignatura,
          required int mes,
          required int anyo}) =>
      _proveedorListasAsistencia.obtenerListasAsistenciasMes(
          idAsignatura: idAsignatura, mes: mes, anyo: anyo);

  //Metodo para eliminar las listas de asistencia de dia y de mes
  //segun el id de la asignatura
  Future<void> eliminarListasAsistencia({required String idAsignatura}) =>
      _proveedorListasAsistencia.eliminarListasAsistencias(
          idAsignatura: idAsignatura);

  Future<ListaAsistenciasMes> editarListaAsistenciaDia({
    required ListaAsistenciasDia listaAsistencias,
  }) =>
      _proveedorListasAsistencia.editarListaAsistenciasDia(
          listaAsistenciasDia: listaAsistencias);
}
