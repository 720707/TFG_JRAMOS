import '../../datos/entidades/clase.dart';

import '../proveedores/clases/proveedor_clases.dart';

///Autor: Javier Ramos Marco
/// * Repositorio de clases
///

class RepositorioClases {
  RepositorioClases({
    required ProveedorClases proveedorClases,
  }) : _proveedorClases = proveedorClases;

  final ProveedorClases _proveedorClases;

  Future<void> crearClase(Clase clase) => _proveedorClases.crearClase(clase);

  Stream<Iterable<Clase>> obtenerClasesUsuario({required String idUsuario}) {
    return _proveedorClases.obtenerClasesUsuario(idUsuario: idUsuario);
  }

  Future<void> eliminarClases({required String idAsignatura}) =>
      _proveedorClases.eliminarClases(idAsignatura: idAsignatura);

  Future<void> ponerListaPasadaATrue(Clase clase) =>
      _proveedorClases.ponerListaPasadaATrue(clase);
}
