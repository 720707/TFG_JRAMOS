import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../configuracion/constantes/base_datos_firebase.dart';
import '../../recursos.dart';

import '../../../control/excepciones/base_de_datos/excepciones_base_datos.dart';
import '../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Proveedor de alumnos en firebase
///

class ProveedorAlumnosFirebase implements ProveedorAlumnos {
  final FirebaseFirestore firestore;

  ProveedorAlumnosFirebase({required this.firestore});

  CollectionReference get collecion => firestore.collection(alumnosColeccion);

  @override
  Future<void> anyadirAsignaturaAAlumno({
    required String idAlumno,
    required String idAsignatura,
  }) async {
    await collecion.doc(idAlumno).update({
      campoAsignaturasEnAlumnos: FieldValue.arrayUnion([idAsignatura])
    }).onError(
        (error, stackTrace) => throw const NoSePuedeAnyadirAsignaturaAAlumno());
  }

  @override
  Future<void> crearAlumno(
    Alumno alumno,
  ) async {
    AlumnoDTO alumnoModelo = AlumnoDTO.fromEntity(alumno);
    final alumnoExiste = await collecion.doc(alumno.nipAlumno).get();

    if (!alumnoExiste.exists) {
      await collecion
          .doc(alumno.nipAlumno)
          .set(alumnoModelo.toJson())
          .onError((error, _) => throw const NoSePuedeCrearAlumno());
    }
  }

  //Metodo apara obtener todos los alumnos
  @override
  Future<Alumno> obtenerAlumno(String nipAlumno) async {
    var alumno = await firestore
        .collection(alumnosColeccion)
        .doc(nipAlumno)
        .get()
        .onError((error, _) => throw const NoSePuedeObtenerAlumno());
    return AlumnoDTO.fromJson(alumno.data() ?? {}).toEntity();
  }

  @override
  Future<void> eliminarAsignatura({required String idAsignatura}) async {
    var alumnos = await firestore
        .collection(alumnosColeccion)
        .where("asignaturas", arrayContains: idAsignatura)
        .get();

    for (var alumno in alumnos.docs) {
      await firestore.collection(alumnosColeccion).doc(alumno.id).update({
        "asignaturas": FieldValue.arrayRemove([idAsignatura])
      }).onError(
          (error, _) => throw const NoSePuedeEliminarAsignaturaAAlumno());
    }
  }
}
