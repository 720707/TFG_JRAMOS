import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../datos/datos.dart';
import '../../../recursos/recursos.dart';

part 'listas_asistencia_event.dart';
part 'listas_asistencia_state.dart';

///Autor: Javier Ramos Marco
/// * Bloc para controlar los eventos relacionados con las listas de asistencia
///

class ListasAsistenciaBloc
    extends Bloc<EventoListasAsistencia, EstadoListasAsistencia> {
  final RepositorioListasAsistencia _repositorioListasAsistencia;
  final RepositorioClases _repostiorioClases;
  ListasAsistenciaBloc(
      {required RepositorioListasAsistencia repositorioListasAsistencia,
      required RepositorioClases repositorioClases})
      : _repositorioListasAsistencia = repositorioListasAsistencia,
        _repostiorioClases = repositorioClases,
        super(
          ListasAsistenciaInitial(),
        ) {
    on<PasarListaDia>(((event, emit) async {
      emit(const ListasAsistenciaCargando());
      try {
        await _repositorioListasAsistencia
            .pasarListaAsistenciasDia(event.listaAsistenciasDia);
        await _repostiorioClases.ponerListaPasadaATrue(event.clase);
        emit(ListaAsistenciasDiaPasada(event.listaAsistenciasDia));
      } on Exception catch (e) {
        emit(ListasAsistenciasError(excepcion: e));
      }
    }));

    on<EliminarListasAsistenciaDiayMes>(((event, emit) async {
      emit(const ListasAsistenciaCargando());
      try {
        await _repositorioListasAsistencia.eliminarListasAsistencia(
            idAsignatura: event.idAsignatura);
        emit(const ListasAsistenciaEliminadas());
      } on Exception catch (e) {
        emit(ListasAsistenciasError(excepcion: e));
      }
    }));

    on<EditarListaDia>(((event, emit) async {
      emit(const ListasAsistenciaCargando());
      try {
        var listaAsistenciaMes =
            await _repositorioListasAsistencia.editarListaAsistenciaDia(
                listaAsistencias: event.listaAsistenciasDia);
        emit(ListaAsistenciasEditada(
            listaAsistenciasMesSinEditar: listaAsistenciaMes));
      } on Exception catch (e) {
        emit(ListasAsistenciasError(excepcion: e));
      }
    }));
  }
}
