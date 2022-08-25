import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/base_de_datos/excepciones_base_datos.dart';
import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/parametros.dart';

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;

  setUpAll(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('Proveedor Asignaturas Firebase test', () {
    test('Añadir Asignatura', () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);
      final CollectionReference mockCollectionReference = fakeFirebaseFirestore
          .collection(proveedorAsignaturasFirebase.collecion.path);
      await proveedorAsignaturasFirebase.anyadirAsignatura(
          asignatura: asignaturaSinLista);

      final asignatura = await mockCollectionReference
          .where("idAsignatura", isEqualTo: '4343')
          .get();

      Asignatura asig = AsignaturaDTO.fromJson(
              asignatura.docs.first.data() as Map<String, dynamic>)
          .toEntity();

      expect(asig, asignaturaSinLista);
    });

    test('Obtener asiganturas usuario', () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);

      for (var i = 0; i < asignaturasTestProveedores.length; i++) {
        proveedorAsignaturasFirebase.anyadirAsignatura(
            asignatura: asignaturasTestProveedores.elementAt(i));
      }

      final asignaturasFirebase = await proveedorAsignaturasFirebase
          .obtenerAsignaturasUsuario(idUsuario: '43434');

      expect(asignaturasTestProveedores, asignaturasFirebase);
    });

    test('Actualizar Listas Asistencias Mes En Asignatura sin lista previa',
        () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);

      await proveedorAsignaturasFirebase.anyadirAsignatura(
          asignatura: asignaturaSinLista);

      ListaAsistenciasMes lista = listasAsistenciasMesMockProveedores;

      await proveedorAsignaturasFirebase
          .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
              idAsignatura: asignaturaSinLista.idAsignatura,
              listaAsistenciasMesActualizada: lista);

      List<Asignatura> asignatura = await proveedorAsignaturasFirebase
          .obtenerAsignaturasUsuario(idUsuario: asignaturaSinLista.idProfesor);

      expect(lista.toString(),
          asignatura.first.listasAsistenciasMes.first.toString());
    });

    test('Actualizar Listas Asistencias Mes En Asignatura con lista previa',
        () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);

      await proveedorAsignaturasFirebase.anyadirAsignatura(
          asignatura: asignaturaConLista);

      ListaAsistenciasMes lista = listasAsistenciasMesMockProveedores;

      await proveedorAsignaturasFirebase
          .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
              idAsignatura: asignaturaConLista.idAsignatura,
              listaAsistenciasMesActualizada: lista);

      List<Asignatura> asignatura = await proveedorAsignaturasFirebase
          .obtenerAsignaturasUsuario(idUsuario: asignaturaConLista.idProfesor);

      expect(lista.toString(),
          asignatura.first.listasAsistenciasMes.last.toString());
    });

    test('Eliminar Asignatura', () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);

      final asignaturas = asignaturasTestProveedores;

      for (var i = 0; i < asignaturas.length; i++) {
        proveedorAsignaturasFirebase.anyadirAsignatura(
            asignatura: asignaturas.elementAt(i));
      }

      await proveedorAsignaturasFirebase.eliminarAsignatura(idAsignatura: '1');

      final asignaturasFirebase = await proveedorAsignaturasFirebase
          .obtenerAsignaturasUsuario(idUsuario: '43434');

      asignaturas.removeAt(1);

      expect(asignaturasFirebase, asignaturas);
    });

    test('Eliminar Asignatura lanza excepcion', () async {
      final ProveedorAsignaturasFirebase proveedorAsignaturasFirebase =
          ProveedorAsignaturasFirebase(firestore: fakeFirebaseFirestore);

      final asignaturas = asignaturasTestProveedores;

      for (var i = 0; i < asignaturas.length; i++) {
        proveedorAsignaturasFirebase.anyadirAsignatura(
            asignatura: asignaturas.elementAt(i));
      }

      try {
        await proveedorAsignaturasFirebase.eliminarAsignatura(
            idAsignatura: '10');
      } on Exception catch (e) {
        expect(e, isA<ExcepcionBaseDeDatos>());
      }
    });
  });
}
