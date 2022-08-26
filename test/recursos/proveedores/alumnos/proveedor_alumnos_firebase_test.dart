import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_asistencia_tfg_jrm/recursos/proveedores/alumnos/proveedor_alumnos_firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../../utils/parametros.dart';

void main() {
  final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  final ProveedorAlumnosFirebase proveedorAlumnosFirebase =
      ProveedorAlumnosFirebase(firestore: fakeFirebaseFirestore);

  group('Proveedor alumnos firebase test', () {
    test('Anyadir Asignatura A Alumno', () async {
      final CollectionReference mockCollectionReference = fakeFirebaseFirestore
          .collection(proveedorAlumnosFirebase.collecion.path);
      await mockCollectionReference
          .doc(alumnoDTO.nipAlumno)
          .set(alumnoDTO.toJson());

      await proveedorAlumnosFirebase.anyadirAsignaturaAlumno(
          idAlumno: alumnoDTO.nipAlumno, idAsignatura: '76776');

      final alumno =
          await proveedorAlumnosFirebase.obtenerAlumno(alumnoDTO.nipAlumno);

      expect(alumno.asignaturas, ['2342342', 'Matematicas', '76776']);
    });

    test('Crear Alumno y Obtener Alumno', () async {
      await proveedorAlumnosFirebase.crearAlumno(alumnos.first);

      final alumno =
          await proveedorAlumnosFirebase.obtenerAlumno(alumnos.first.nipAlumno);

      expect(alumno, alumnos.first);
    });

    test('Eliminar Asignatura', () async {
      final CollectionReference mockCollectionReference = fakeFirebaseFirestore
          .collection(proveedorAlumnosFirebase.collecion.path);

      await mockCollectionReference
          .doc(alumnoDTO.nipAlumno)
          .set(alumnoDTO.toJson());

      await proveedorAlumnosFirebase.eliminarAsignatura(
          idAsignatura: '2342342');

      final alumno =
          await proveedorAlumnosFirebase.obtenerAlumno(alumnoDTO.nipAlumno);

      expect(alumno.asignaturas, ["Matematicas"]);
    });
  });
}
