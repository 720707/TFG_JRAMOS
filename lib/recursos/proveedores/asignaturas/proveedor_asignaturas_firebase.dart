import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../configuracion/constantes/base_datos_firebase.dart';
import '../../../control/excepciones/excepciones.dart';
import '../../../datos/datos.dart';
import '../../recursos.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de listas de asiganturas en firebase
///

class ProveedorAsignaturasFirebase implements ProveedorAsignaturas {
  final FirebaseFirestore firestore;

  ProveedorAsignaturasFirebase({required this.firestore});

  CollectionReference get collecion =>
      firestore.collection(asignaturaColeccion);

  @override
  Future<void> anyadirAsignatura({
    required Asignatura asignatura,
  }) async {
    AsignaturaDTO asignaturaModelo = AsignaturaDTO.fromEntity(asignatura);

    await firestore
        .collection(asignaturaColeccion)
        .doc(asignatura.idAsignatura)
        .set(asignaturaModelo.toJson())
        .onError((error, _) => throw const NoSePuedeAnyadirAsignaturaAlumno());
  }

  @override
  Future<List<Asignatura>> obtenerAsignaturasUsuario(
      {required String idUsuario}) {
    var resultado = firestore
        .collection(asignaturaColeccion)
        .where(profesorIdCampo, isEqualTo: idUsuario)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AsignaturaDTO.fromJson(doc.data()).toEntity())
          .toList();
    });
    return resultado.first;
  }

  @override
  Future<void> actualizarListasAsistenciasMesEnAsignatura(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesSinActualizar,
      required ListaAsistenciasMes listaAsistenciasMesActualizada}) async {
    ListaAsistenciasMesDTO listaAsistenciasMesModeloSinActualizar =
        ListaAsistenciasMesDTO.fromEntity(listaAsistenciasMesSinActualizar);

    ListaAsistenciasMesDTO listaAsistenciaMesModeloActualizada =
        ListaAsistenciasMesDTO.fromEntity(listaAsistenciasMesActualizada);

    await quitarListaAsistenciaMesEnAsignatura(
        idAsignatura, listaAsistenciasMesModeloSinActualizar);

    await insertarListaMesActualizadaEnAsignatura(
        idAsignatura, listaAsistenciaMesModeloActualizada);
  }

  Future<void> insertarListaMesActualizadaEnAsignatura(String idAsignatura,
      ListaAsistenciasMesDTO listaAsistenciaMesModeloActualizada) async {
    return await firestore
        .collection(asignaturaColeccion)
        .doc(idAsignatura)
        .update({
      campoListasAsistenciasMes:
          FieldValue.arrayUnion([listaAsistenciaMesModeloActualizada.toJson()])
    }).onError((error, _) =>
            throw const NoSePuedeActualizarListaAsistenciaEnAsignatura());
  }

  Future<void> quitarListaAsistenciaMesEnAsignatura(String idAsignatura,
      ListaAsistenciasMesDTO listaAsistenciasMesModeloSinActualizar) async {
    return await firestore
        .collection(asignaturaColeccion)
        .doc(idAsignatura)
        .update({
      campoListasAsistenciasMes: FieldValue.arrayRemove(
          [listaAsistenciasMesModeloSinActualizar.toJson()])
    }).onError((error, _) =>
            throw const NoSePuedeEliminarListaAsistenciaEnAsignatura());
  }

  @override
  Future<void> actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
      {required String idAsignatura,
      required ListaAsistenciasMes listaAsistenciasMesActualizada}) async {
    ListaAsistenciasMesDTO listaAsistenciaMesModeloActualizada =
        ListaAsistenciasMesDTO.fromEntity(listaAsistenciasMesActualizada);
    await insertarListaMesActualizadaEnAsignatura(
        idAsignatura, listaAsistenciaMesModeloActualizada);
  }

  @override
  Future<void> eliminarAsignatura({required String idAsignatura}) async {
    await firestore
        .collection(asignaturaColeccion)
        .doc(idAsignatura)
        .delete()
        .onError((error, stackTrace) => throw NoSePuedeEliminarAsignatura);
  }

  @override
  Future<void> editarListaAsistenciasDia(
      {required ListaAsistenciasMes listaAsistenciasMesSinEditar,
      required Asignatura asignatura}) async {
    ListaAsistenciasMesDTO listaAsistenciasMesSinEditarModelo =
        ListaAsistenciasMesDTO.fromEntity(listaAsistenciasMesSinEditar);

    await firestore
        .collection(asignaturaColeccion)
        .doc(asignatura.idAsignatura)
        .update({
      campoListasAsistenciasMes:
          FieldValue.arrayRemove([listaAsistenciasMesSinEditarModelo.toJson()])
    }).onError((error, _) =>
            throw const NoSePuedeEditarListaAsistenciaDiaEnAsignatura());

    var listaAsistenciaMesModificada = await firestore
        .collection(listasAsistenciasMesColeccion)
        .where(idAsignaturaCampo,
            isEqualTo: listaAsistenciasMesSinEditarModelo.idAsignatura)
        .where("anyo", isEqualTo: listaAsistenciasMesSinEditar.anyo.toInt())
        .where("mes", isEqualTo: listaAsistenciasMesSinEditar.mes.toInt())
        .get();

    await firestore
        .collection(asignaturaColeccion)
        .doc(asignatura.idAsignatura)
        .update({
      campoListasAsistenciasMes: FieldValue.arrayUnion(
          [listaAsistenciaMesModificada.docs.first.data()])
    }).onError((error, _) =>
            throw const NoSePuedeEditarListaAsistenciaDiaEnAsignatura());
  }
}
