import 'package:control_asistencia_tfg_jrm/control/excepciones/excepciones.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/clase.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/parametros.dart';

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;

  setUpAll(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });
  group('Proveedor clases firebase test', () {
    test('Crear Clase', () async {
      final ProveedorClasesFirebase proveedorClasesFirebase =
          ProveedorClasesFirebase(firestore: fakeFirebaseFirestore);

      await proveedorClasesFirebase.crearClase(clase);

      Clase claseFinal = await obtenerClase(proveedorClasesFirebase);

      expect(claseFinal, clase);
    });

    test('Eliminar clase', () async {
      final ProveedorClasesFirebase proveedorClasesFirebase =
          ProveedorClasesFirebase(firestore: fakeFirebaseFirestore);

      await proveedorClasesFirebase.crearClase(clase);

      await proveedorClasesFirebase.eliminarClases(
          idAsignatura: clase.idAsignatura);

      final clasesFirebase = proveedorClasesFirebase.obtenerClasesUsuario(
          idUsuario: clase.idProfesor);

      var claseConcreta = await clasesFirebase.first;

      expect(claseConcreta, []);
    });

    test('Eliminar clase lanza excepcion en caso de fallo', () async {
      final ProveedorClasesFirebase proveedorClasesFirebase =
          ProveedorClasesFirebase(firestore: fakeFirebaseFirestore);

      await proveedorClasesFirebase.crearClase(clase);

      try {
        await proveedorClasesFirebase.eliminarClases(idAsignatura: '54545');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionBaseDeDatos>());
      }
    });

    test('Poner lista pasada a true', () async {
      final ProveedorClasesFirebase proveedorClasesFirebase =
          ProveedorClasesFirebase(firestore: fakeFirebaseFirestore);

      await proveedorClasesFirebase.crearClase(clase);

      await proveedorClasesFirebase.ponerListaPasadaATrue(clase);

      Clase claseFinal = await obtenerClase(proveedorClasesFirebase);

      expect(claseFinal.listaPasada, true);
    });
  });
}

Future<Clase> obtenerClase(
    ProveedorClasesFirebase proveedorClasesFirebase) async {
  final clasesFirebase =
      proveedorClasesFirebase.obtenerClasesUsuario(idUsuario: clase.idProfesor);

  var claseConcreta = await clasesFirebase.first;

  final claseFinal = claseConcreta.first;
  return claseFinal;
}
