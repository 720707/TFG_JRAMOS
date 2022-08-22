import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de listas de asistencia
///

abstract class ProveedorListasAsistencia {
  const ProveedorListasAsistencia();

  /// Método para crear la lista de asistencia dia para una asignatura
  Future<void> pasarListaAsistenciasDia(
    ListaAsistenciasDia listaAistenciasDia,
  );

  Future<void> actualizarListaAsistenciasMes({
    required ListaAsistenciasDia listaAsistenciasDia,
    required ListaAsistenciasMes listaAistenciasMes,
  });

  Future<List<ListaAsistenciasMes>> obtenerListasAsistenciasMes(
      {required String idAsignatura, required int mes, required int anyo});

  Future<void> eliminarListasAsistencias({required String idAsignatura});

  Future<ListaAsistenciasMes> editarListaAsistenciasDia({
    required ListaAsistenciasDia listaAsistenciasDia,
  });
}
