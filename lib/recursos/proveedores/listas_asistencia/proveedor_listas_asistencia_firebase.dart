import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../configuracion/configuracion.dart';
import '../../../control/excepciones/base_de_datos/excepciones_base_datos.dart';
import '../../../datos/datos.dart';
import '../../DTO/DTO.dart';
import 'proveedor_listas_asistencia.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de listas de asistencia para firebase
///

class ProveedorListasAsistenciaFirebase implements ProveedorListasAsistencia {
  final FirebaseFirestore firestore;

  ProveedorListasAsistenciaFirebase({required this.firestore});

  CollectionReference get collecionListaAsistenciasDia =>
      firestore.collection(listasAsistenciasDiaColeccion);

  CollectionReference get collecionListaAsistenciasMes =>
      firestore.collection(listasAsistenciasMesColeccion);

  @override
  Future<void> pasarListaAsistenciasDia(
      ListaAsistenciasDia listaAsistenciasDia) async {
    ListaAsistenciasDiaDTO listaAsistenciasDiaModelo =
        ListaAsistenciasDiaDTO.fromEntity(listaAsistenciasDia);

    await firestore
        .collection(listasAsistenciasDiaColeccion)
        .doc(listaAsistenciasDiaModelo.idListaAsistenciasDia)
        .set(listaAsistenciasDiaModelo.toJson())
        .onError((error, _) => throw const NoSePuedeCrearListaAsistenciaDia());
  }

  @override
  //Metodo para actualizar la lista de asistencia del mes si existe y crea
  //una nueva si no existe
  Future<void> actualizarListaAsistenciasMes(
      {required ListaAsistenciasDia listaAsistenciasDia,
      required ListaAsistenciasMes listaAistenciasMes}) async {
    ListaAsistenciasMesDTO listaAsistenciasMesModelo =
        ListaAsistenciasMesDTO.fromEntity(listaAistenciasMes);

    ListaAsistenciasDiaDTO listaAsistenciasDiaModelo =
        ListaAsistenciasDiaDTO.fromEntity(listaAsistenciasDia);

    final listaAsistenciaMesExiste =
        await obtenerListaAsistenciaMes(listaAistenciasMes);

    if (listaAsistenciaMesExiste.exists) {
      await actualizarListaMesExistente(
          listaAistenciasMes, listaAsistenciasDiaModelo);
    } else {
      await crearListaAsistenciasMes(listaAsistenciasMesModelo);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerListaAsistenciaMes(
      ListaAsistenciasMes listaAistenciasMes) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(listaAistenciasMes.idListaAsistenciasMes)
        .get();
  }

  Future<void> actualizarListaMesExistente(
      ListaAsistenciasMes listaAistenciasMes,
      ListaAsistenciasDiaDTO listaAsistenciadDiaModelo) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(listaAistenciasMes.idListaAsistenciasMes)
        .update({
      "listaAsistenciasDia":
          FieldValue.arrayUnion([listaAsistenciadDiaModelo.toJson()])
    }).onError((error, _) =>
            throw const ExcepcionNoSePuedeAnyadirListaAsistenciaMes());
  }

  Future<void> crearListaAsistenciasMes(
      ListaAsistenciasMes listaAsistenciasMesModelo) async {
    ListaAsistenciasMesDTO listaAsistenciasMes =
        ListaAsistenciasMesDTO.fromEntity(listaAsistenciasMesModelo);
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(listaAsistenciasMesModelo.idListaAsistenciasMes)
        .set(listaAsistenciasMes.toJson())
        .onError((error, _) =>
            throw const ExcepcionNoSePuedeCrearListaAsistenciaMes());
  }

  //Metodo para obtener todas las listas de asistencia mes de una asignatura
  @override
  Future<List<ListaAsistenciasMes>> obtenerListasAsistenciasMes(
      {required String idAsignatura,
      required int mes,
      required int anyo}) async {
    var resultado = firestore
        .collection(listasAsistenciasMesColeccion)
        .where(campoIdAsignatura, isEqualTo: idAsignatura)
        .where("mes", isEqualTo: mes)
        .where("anyo", isEqualTo: anyo)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ListaAsistenciasMesDTO.fromJson(doc.data()).toEntity())
          .toList();
    });

    var listaAsistencia = resultado.first;
    return listaAsistencia;
  }

  //Método para eliminar todas las listas de asistencia de dia y mes de un usuario
  @override
  Future<void> eliminarListasAsistencias({required String idAsignatura}) async {
    var asistenciasDia = await firestore
        .collection(listasAsistenciasDiaColeccion)
        .where(idAsignaturaCampo, isEqualTo: idAsignatura)
        .get();

    var asistenciasMes = await firestore
        .collection(listasAsistenciasMesColeccion)
        .where(idAsignaturaCampo, isEqualTo: idAsignatura)
        .get();

    for (var element in asistenciasDia.docs) {
      await firestore
          .collection(listasAsistenciasDiaColeccion)
          .doc(element.id)
          .delete();
    }

    for (var element in asistenciasMes.docs) {
      await firestore
          .collection(listasAsistenciasMesColeccion)
          .doc(element.id)
          .delete();
    }
  }

  Future<void> quitarListaAsistenciaDiaEnMes(
      {required QueryDocumentSnapshot<Map<String, dynamic>> element,
      required ListaAsistenciasDiaDTO listaAsistenciasDiaModelo}) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(element.id)
        .update({
      campoListaAsistenciaDia:
          FieldValue.arrayRemove([listaAsistenciasDiaModelo.toJson()])
    });
  }

  //Funcion para editar la lista de asistencias dia tanto en
  //listaAsistenciasDia y en listaAsistenciasMes
  @override
  Future<ListaAsistenciasMes> editarListaAsistenciasDia({
    required ListaAsistenciasDia listaAsistenciasDia,
  }) async {
    ListaAsistenciasDiaDTO listaAsistenciasModelo =
        ListaAsistenciasDiaDTO.fromEntity(listaAsistenciasDia);

    var listaAsistenciasDiaSinEditar =
        await obtenerListaAsistenciaDia(listaAsistenciasDia);

    await eliminarListaAsistenciasDia(listaAsistenciasDia);

    await ponerListaAsistenciasDia(listaAsistenciasModelo);

    var listaAsistenciasMes =
        await obtenerListaAsistenciasMes(listaAsistenciasDia);

    for (var element in listaAsistenciasMes.docs) {
      await eliminarListaAsistenciasDiaEnListaAsistenciasMes(
          element, listaAsistenciasDiaSinEditar);

      await ponerListaAsistenciasDiaEnListaAsistenciasMes(
          element, listaAsistenciasModelo);
    }

    return ListaAsistenciasMesDTO.fromJson(
            listaAsistenciasMes.docs.first.data())
        .toEntity();
  }

  Future<void> ponerListaAsistenciasDia(
      ListaAsistenciasDiaDTO listaAsistenciasModelo) async {
    return await firestore
        .collection(listasAsistenciasDiaColeccion)
        .doc(listaAsistenciasModelo.idListaAsistenciasDia)
        .set(listaAsistenciasModelo.toJson())
        .onError(
            (error, _) => const ExcepcionNoSePuedeEditarListaAsistenciaDia());
  }

  Future<void> ponerListaAsistenciasDiaEnListaAsistenciasMes(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      ListaAsistenciasDiaDTO listaAsistenciasModelo) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(element.id)
        .update({
      campoListaAsistenciaDia:
          FieldValue.arrayUnion([listaAsistenciasModelo.toJson()])
    });
  }

  Future<void> eliminarListaAsistenciasDiaEnListaAsistenciasMes(
      QueryDocumentSnapshot<Map<String, dynamic>> element,
      DocumentSnapshot<Map<String, dynamic>>
          listaAsistenciasDiaSinEditar) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .doc(element.id)
        .update({
      campoListaAsistenciaDia:
          FieldValue.arrayRemove([listaAsistenciasDiaSinEditar.data()])
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> obtenerListaAsistenciasMes(
      ListaAsistenciasDia listaAsistenciasDia) async {
    return await firestore
        .collection(listasAsistenciasMesColeccion)
        .where("idAsignatura", isEqualTo: listaAsistenciasDia.idAsignatura)
        .where("anyo", isEqualTo: listaAsistenciasDia.fecha.year.toInt())
        .where("mes", isEqualTo: listaAsistenciasDia.fecha.month.toInt())
        .get();
  }

  Future<void> eliminarListaAsistenciasDia(
      ListaAsistenciasDia listaAsistenciasDia) async {
    return await firestore
        .collection(listasAsistenciasDiaColeccion)
        .doc(listaAsistenciasDia.idListaAsistenciasDia)
        .delete()
        .onError(
            (error, _) => const ExcepcionNoSePuedeEditarListaAsistenciaDia());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerListaAsistenciaDia(
      ListaAsistenciasDia listaAsistencias) async {
    return await firestore
        .collection(listasAsistenciasDiaColeccion)
        .doc(listaAsistencias.idListaAsistenciasDia)
        .get();
  }
}
