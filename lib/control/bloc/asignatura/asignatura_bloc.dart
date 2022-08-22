import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import '../../../configuracion/configuracion.dart';
import '../../../datos/datos.dart';
import '../../../utilidades/crear_clases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../recursos/recursos.dart';
import '../../../utilidades/generar_pdf.dart';
import '../../../utilidades/procesamiento_excel.dart';

part 'asignatura_event.dart';
part 'asignatura_state.dart';

///Autor: Javier Ramos Marco
/// * Bloc para controlar los eventos relacionados con la asignatura
///

class AsignaturaBloc extends Bloc<EventoAsignatura, EstadoAsignatura> {
  final RepositorioAlumnos _repositorioAlumnos;
  final RepositorioAsignaturas _repositorioAsignaturas;
  final RepositorioClases _repositorioClases;
  final RepositorioListasAsistencia _repositorioListasAsistencia;
  final GeneradorClases _generadorClases;
  final GeneradorPdf _generadorPDF;
  final ProcesadorExcel _procesadorExcel;

  AsignaturaBloc({
    required RepositorioAlumnos repositorioAlumnos,
    required RepositorioAsignaturas repositorioAsignaturas,
    required RepositorioClases repositorioClases,
    required RepositorioListasAsistencia repositorioListasAsistencia,
    required GeneradorClases generadorClases,
    required GeneradorPdf generadorPDF,
    required ProcesadorExcel procesadorExcel,
  })  : _repositorioAlumnos = repositorioAlumnos,
        _repositorioAsignaturas = repositorioAsignaturas,
        _repositorioClases = repositorioClases,
        _repositorioListasAsistencia = repositorioListasAsistencia,
        _generadorClases = generadorClases,
        _generadorPDF = generadorPDF,
        _procesadorExcel = procesadorExcel,
        super(AsignaturaInitial()) {
    on<CargarListaAlumnos>(((event, emit) async {
      emit(const AsignaturaCargando());

      List<Alumno> alumnos = await _procesadorExcel.procesar();

      try {
        for (Alumno alumno in alumnos) {
          await _repositorioAlumnos.crearAlumno(alumno);
        }
        emit(AlumnosCargados(alumnos));
      } on Exception catch (e) {
        emit(AsignaturaError(excepcion: e, mensaje: textoNoSePuedeCrearAlumno));
        emit(const AsignaturaAnyadida());
      }
    }));

    on<AnyadirAsignatura>(((event, emit) async {
      try {
        await _repositorioAsignaturas.anyadirAsignatura(event.asignatura);

        for (Alumno alumno in event.alumnos) {
          await repositorioAlumnos.anyadirAsignaturaAAlumno(
              idAlumno: alumno.nipAlumno,
              idAsignatura: event.asignatura.idAsignatura);
        }

        emit(AsignaturaCargada(
            alumnos: event.alumnos, asignatura: event.asignatura));
      } on Exception catch (e) {
        emit(AsignaturaError(
            excepcion: e, mensaje: textoNoSePuedeCrearAsignatura));
        emit(const AsignaturaAnyadida());
      }
    }));

    on<CrearClases>(((event, emit) async {
      emit(const AsignaturaCargando());

      List<Clase> clases = _generadorClases.crearClases(
          asignatura: event.asignatura, alumnos: event.alumnos);

      try {
        for (Clase clase in clases) {
          await _repositorioClases.crearClase(clase);
        }
        emit(const ClasesCreadas());
      } on Exception catch (e) {
        emit(AsignaturaError(excepcion: e, mensaje: textoNoSePuedeCrearClase));
        emit(const AsignaturaAnyadida());
      }
    }));

    on<EliminarAsignatura>(((event, emit) async {
      try {
        emit(const AsignaturaCargando());
        await _repositorioAsignaturas.eliminarAsignatura(
            idAsignatura: event.idAsignatura);

        await _repositorioClases.eliminarClases(
            idAsignatura: event.idAsignatura);

        await _repositorioAlumnos.eliminarAsignaturEnAlumno(
            idAsignatura: event.idAsignatura);
        emit(
            AsignaturaEliminadaCorrectamente(idAsignatura: event.idAsignatura));
      } on Exception catch (e) {
        emit(AsignaturaError(
            excepcion: e, mensaje: textoNoSePuedeEliminarAsignatura));
      }
    }));

    //Metodo para actualizar la lista de asistencia en la coleccion asignatura
    //en caso de que no exista previamente la crea y si no añade una nueva lista
    //de asistencia dia a la asigantura
    on<ActualizarListasAsistenciaDia>(((event, emit) async {
      emit(const AsignaturaCargando());
      List<ListaAsistenciasDia> listaAsistencias = [];
      listaAsistencias.add(event.listaAsistenciasDia);
      try {
        ListaAsistenciasMes listaAsistenciaMes = ListaAsistenciasMes(
          idListaAsistenciasMes: event.listaAsistenciasDia.idAsignatura +
              event.listaAsistenciasDia.fecha.month.toString() +
              event.listaAsistenciasDia.fecha.year.toString(),
          mes: event.listaAsistenciasDia.fecha.month,
          anyo: event.listaAsistenciasDia.fecha.year,
          idAsignatura: event.listaAsistenciasDia.idAsignatura,
          listaAsistenciasDia: listaAsistencias,
        );

        List<ListaAsistenciasMes> listaAsistenciasMesSinActualizar =
            await _obtenerListaAsistenciaMes(
          anyo: event.listaAsistenciasDia.fecha.year,
          idAsignatura: event.listaAsistenciasDia.idAsignatura,
          mes: event.listaAsistenciasDia.fecha.month,
        );

        await _repositorioListasAsistencia.actualizarListaAsistenciasMes(
            listaAsistenciasDia: event.listaAsistenciasDia,
            listaAsistenciasMes: listaAsistenciaMes);

        List<ListaAsistenciasMes> listaAsistenciasMesActualizada =
            await _obtenerListaAsistenciaMes(
          anyo: event.listaAsistenciasDia.fecha.year,
          idAsignatura: event.listaAsistenciasDia.idAsignatura,
          mes: event.listaAsistenciasDia.fecha.month,
        );

        //En caso de que la lista de asistencias mes no existe previamente
        //se crea, sino se actualiza
        if (listaAsistenciasMesSinActualizar.isEmpty) {
          await _repositorioAsignaturas
              .actualizarListasAsistenciasMesEnAsignaturaSinListaPrevia(
                  idAsignatura: event.listaAsistenciasDia.idAsignatura,
                  listaAsistenciasMesActualizada:
                      listaAsistenciasMesActualizada.first);
        } else {
          await _repositorioAsignaturas
              .actualizarListasAsistenciasMesEnAsignatura(
                  idAsignatura: event.listaAsistenciasDia.idAsignatura,
                  listaAsistenciasMesSinActualizar:
                      listaAsistenciasMesSinActualizar.first,
                  listaAsistenciasMesActualizada:
                      listaAsistenciasMesActualizada.first);
        }
        emit(const ListasActualizadas());
      } on Exception catch (e) {
        emit(AsignaturaError(
            excepcion: e, mensaje: noSePuedeActualizarListaAsistenciaDia));
      }
    }));

    //Evento que se produce cuando se selecciona la opcion de Asignaturas en el pop up menu
    on<ObtenerAsignaturas>(((event, emit) async {
      try {
        final asignaturas = await _repositorioAsignaturas
            .obtenerAsignaturasUsuario(idUsuario: event.idUsuario);
        emit(AsignaturasUsuarioObtenidas(asignaturas: asignaturas));
      } on Exception catch (e) {
        emit(AsignaturaError(
            excepcion: e, mensaje: textoNoSePuedeObtenerAsignatura));
      }
    }));

    on<GenerarPDF>(((event, emit) async {
      List<AlumnoPDF> alumnos = _generadorPDF.generarAlumnosPdf(
          listaAsistenciasMes: event.listaAsistenciasMes,
          asignatura: event.asignatura);

      try {
        final data = await _generadorPDF.generarPdf(
            alumnos: alumnos, listaAsistencias: event.listaAsistenciasMes);

        emit(PdfGenerado(
            pdf: data, listaAsistenciaMes: event.listaAsistenciasMes));
      } on Exception catch (e) {
        emit(AsignaturaError(excepcion: e, mensaje: textoNoSePuedeGenerarPDF));
      }
    }));

    on<EditarListaEnAsignatura>(((event, emit) async {
      emit(const AsignaturaCargando());
      try {
        await _repositorioAsignaturas.editarListaAsistenciasDia(
            listaAsistenciasMesSinEditar: event.listaAsistenciasMesSinEditar,
            asignatura: event.asignatura);

        emit(const ListaAsistenciasEditadaEnAsignatura());
      } on Exception catch (e) {
        emit(AsignaturaError(
            excepcion: e, mensaje: textoNoSePuedeEditarListaAsistencia));
      }
    }));
  }

  Future<List<ListaAsistenciasMes>> _obtenerListaAsistenciaMes(
      {required String idAsignatura,
      required int mes,
      required int anyo}) async {
    return await _repositorioListasAsistencia.obtenerListaAsistenciasMes(
        idAsignatura: idAsignatura, mes: mes, anyo: anyo);
  }
}
