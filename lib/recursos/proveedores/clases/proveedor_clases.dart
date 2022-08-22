import '../../../datos/entidades/clase.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de clases
///

abstract class ProveedorClases {
  const ProveedorClases();

  /// Método para crear una clase
  Future<void> crearClase(
    Clase clase,
  );

  Stream<Iterable<Clase>> obtenerClasesUsuario({required String idUsuario});

  Future<void> eliminarClases({required String idAsignatura});

  Future<void> ponerListaPasadaATrue(Clase clase);
}
