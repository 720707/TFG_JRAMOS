import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/parametros.dart';

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  setUpAll(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });
  group('Listas asistencias firebase test', () {
    test(
        '''Pasar Lista Asistencia Dia, crear lista asistencia mes y actualizar
         lista asistencia mes test''',
        () async {
      final ProveedorListasAsistenciaFirebase proveedorListasAsistencias =
          ProveedorListasAsistenciaFirebase(firestore: fakeFirebaseFirestore);

      final listaAsistencia = listaAsistenciasDia.elementAt(2);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      await proveedorListasAsistencias
          .pasarListaAsistenciasDia(listaAsistencia);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      final listaAsistenciaMes =
          await proveedorListasAsistencias.obtenerListasAsistenciasMes(
              idAsignatura: listasAsistenciasMesMockFirebase.first.idAsignatura,
              mes: listasAsistenciasMesMockFirebase.first.mes,
              anyo: listasAsistenciasMesMockFirebase.first.anyo);

      expect(listaAsistenciaMes.first.listaAsistenciasDia.first.toString(),
          listaAsistencia.toString());
    });

    test('Eliminar lista de asistencia mes', () async {
      final ProveedorListasAsistenciaFirebase proveedorListasAsistencias =
          ProveedorListasAsistenciaFirebase(firestore: fakeFirebaseFirestore);

      final listaAsistencia = listaAsistenciasDia.elementAt(2);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      await proveedorListasAsistencias.eliminarListasAsistencias(
          idAsignatura: '4334');

      final listaAsistencias =
          await proveedorListasAsistencias.obtenerListasAsistenciasMes(
              idAsignatura: '4334',
              mes: listasAsistenciasMesMockFirebase.first.mes,
              anyo: listasAsistenciasMesMockFirebase.first.anyo);

      expect(listaAsistencias, []);
    });

    test('Editar lista asistencia dia ', () async {
      final ProveedorListasAsistenciaFirebase proveedorListasAsistencias =
          ProveedorListasAsistenciaFirebase(firestore: fakeFirebaseFirestore);

      final listaAsistencia = listaAsistenciasDiaParaProveedores.elementAt(2);
      final listaAsistenciaEditada = listaAsistenciasDiaEditada.elementAt(2);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      await proveedorListasAsistencias.actualizarListaAsistenciasMes(
          listaAistenciasMes: listasAsistenciasMesMockFirebase.first,
          listaAsistenciasDia: listaAsistencia);

      await proveedorListasAsistencias
          .pasarListaAsistenciasDia(listaAsistencia);

      await proveedorListasAsistencias.editarListaAsistenciasDia(
          listaAsistenciasDia: listaAsistenciaEditada);

      final listaAsistenciasMes =
          await proveedorListasAsistencias.obtenerListasAsistenciasMes(
              idAsignatura: listasAsistenciasMesMockFirebase.first.idAsignatura,
              mes: listasAsistenciasMesMockFirebase.first.mes,
              anyo: listasAsistenciasMesMockFirebase.first.anyo);

      expect(listaAsistenciasMes.first.listaAsistenciasDia.first.toString(),
          listaAsistenciaEditada.toString());
    });
  });
}
