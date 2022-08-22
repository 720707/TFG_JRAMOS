import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de listas de asignaturas
///

abstract class ProveedorAsignaturas {
  const ProveedorAsignaturas();

  Future<void> anyadirAsignatura({
    required Asignatura asignatura,
  });

  Future<List<Asignatura>> obtenerAsignaturasUsuario(
      {required String idUsuario});

  Future<void> actualizarListasAsistenciasMesEnAsignatura(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesSinActualizar,
      required ListaAsistenciasMes listaAsistenciasMesActualizada});

  Future<void> actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesActualizada});

  Future<void> eliminarAsignatura({required String idAsignatura});

  Future<void> editarListaAsistenciasDia(
      {required Asignatura asignatura,
      required ListaAsistenciasMes listaAsistenciasMesSinEditar});
}
