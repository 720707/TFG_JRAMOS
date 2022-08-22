import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'recursos/recursos.dart';
import 'utilidades/crear_clases.dart';
import 'utilidades/generar_pdf.dart';
import 'utilidades/procesamiento_excel.dart';

///Autor: Javier Ramos Marco
/// * Clase donde se realiza la inyeccion de dependencias
///

final sl = GetIt.instance;

void inicializar() {
  inicializarRepostiorio();
  inicializarProveedores();
  inicializarUilidades();
  inicializarServiciosTerceros();
}

void inicializarRepostiorio() {
  sl.registerLazySingleton<RepositorioAutenticacion>(
      () => RepositorioAutenticacion(proveedorAutenticacion: sl()));
  sl.registerLazySingleton<RepositorioAlumnos>(
      () => RepositorioAlumnos(proveedorAlumnos: sl()));
  sl.registerLazySingleton<RepositorioAsignaturas>(
      () => RepositorioAsignaturas(proveedorAsignaturas: sl()));
  sl.registerLazySingleton<RepositorioClases>(
      () => RepositorioClases(proveedorClases: sl()));
  sl.registerLazySingleton<RepositorioListasAsistencia>(
      () => RepositorioListasAsistencia(proveedorListasAsistencia: sl()));
}

void inicializarUilidades() {
  sl.registerLazySingleton<GeneradorClases>(() => GeneradorClases());
  sl.registerLazySingleton<GeneradorPdf>(() => GeneradorPdf());
  sl.registerLazySingleton<ProcesadorExcel>(() => ProcesadorExcel());
}

void inicializarProveedores() {
  sl.registerLazySingleton<ProveedorAlumnos>(
      () => ProveedorAlumnosFirebase(firestore: sl()));
  sl.registerLazySingleton<ProveedorAutenticacion>(
      () => ProveedorAutenticacionFirebase(firebaseAuth: sl()));
  sl.registerLazySingleton<ProveedorAsignaturas>(
      () => ProveedorAsignaturasFirebase(firestore: sl()));
  sl.registerLazySingleton<ProveedorClases>(
      () => ProveedorClasesFirebase(firestore: sl()));
  sl.registerLazySingleton<ProveedorListasAsistencia>(
      () => ProveedorListasAsistenciaFirebase(firestore: sl()));
}

void inicializarServiciosTerceros() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}
