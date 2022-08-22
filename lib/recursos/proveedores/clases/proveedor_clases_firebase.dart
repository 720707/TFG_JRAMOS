import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../configuracion/constantes/base_datos_firebase.dart';
import '../../../control/excepciones/base_de_datos/excepciones_base_datos.dart';
import '../../../datos/entidades/clase.dart';
import '../../DTO/DTO.dart';
import 'proveedor_clases.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de clases en firebase
///

class ProveedorClasesFirebase implements ProveedorClases {
  final FirebaseFirestore firestore;

  ProveedorClasesFirebase({required this.firestore});

  CollectionReference get collecion => firestore.collection(claseColeccion);

  @override
  Future<void> crearClase(Clase clase) async {
    ClaseDTO claseModelo = ClaseDTO.fromEntity(clase);

    //log('El json de la lista asistencia es ${claseModelo.toJson().toString()}');
    await collecion
        .doc(clase.idClase)
        .set(claseModelo.toJson())
        .onError((error, _) => throw const ExcepcionNoSePuedeCrearClase());
  }

  @override
  Stream<Iterable<Clase>> obtenerClasesUsuario({required String idUsuario}) {
    final allClases = firestore
        .collection(claseColeccion)
        .where(profesorIdCampo, isEqualTo: idUsuario)
        .snapshots()
        .map((clases) => clases.docs
            .map((doc) => ClaseDTO.fromJson(doc.data()).toEntity())
            .where((clase) => clase.idProfesor == idUsuario));

    return allClases;
  }

  @override
  Future<void> eliminarClases({required String idAsignatura}) async {
    var clases =
        await collecion.where(idAsignaturaCampo, isEqualTo: idAsignatura).get();

    for (var element in clases.docs) {
      await collecion
          .doc(element.id)
          .delete()
          .onError((error, _) => throw const NoSePuedenEliminarClases());
    }
  }

  @override
  Future<void> ponerListaPasadaATrue(Clase clase) async {
    collecion
        .doc(clase.idClase)
        .update({campoListaPasadaEnClase: true}).onError(
            (error, _) => throw const NoSeHaPodidoPonerListaPasadaATure());
  }
}
