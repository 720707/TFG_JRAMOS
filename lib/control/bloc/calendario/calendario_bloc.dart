import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../datos/datos.dart';
import '../../../recursos/recursos.dart';
import '../../../recursos/repositorios/repositorio_clases.dart';

part 'calendario_event.dart';
part 'calendario_state.dart';

///Autor: Javier Ramos Marco
/// * Bloc para controlar los eventos relacionados con el calendario
///

class CalendarioBloc extends Bloc<EventoCalendario, EstadoCalendario> {
  final RepositorioClases _repositorioClases;

  CalendarioBloc({required RepositorioClases repositorioClases})
      : _repositorioClases = repositorioClases,
        super(CalendarioInitial()) {
    on<CargarClasesUsuario>((event, emit) async {
      Stream<Iterable<Clase>> clasesStream =
          _repositorioClases.obtenerClasesUsuario(idUsuario: event.idUsuario);

      emit(ClasesCargadas(clases: clasesStream));
    });
  }
}
