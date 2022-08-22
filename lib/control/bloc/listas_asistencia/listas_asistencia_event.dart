part of 'listas_asistencia_bloc.dart';

///Autor: Javier Ramos Marco
/// * Eventos del bloc ListasAsistenciasBloc
///

abstract class EventoListasAsistencia extends Equatable {
  const EventoListasAsistencia();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando se selecciona el boton de pasar lista
//desde la vista de listas de asistencia
class PasarListaDia extends EventoListasAsistencia {
  final ListaAsistenciasDia listaAsistenciasDia;
  final Clase clase;

  const PasarListaDia({required this.listaAsistenciasDia, required this.clase});

  @override
  List<Object> get props => [listaAsistenciasDia];
}

class EditarListaDia extends EventoListasAsistencia {
  final ListaAsistenciasDia listaAsistenciasDia;

  const EditarListaDia({required this.listaAsistenciasDia});

  @override
  List<Object> get props => [listaAsistenciasDia];
}

//Evento para eliminar todas las listas de asistencia tanto las de dia
//como las de mes
class EliminarListasAsistenciaDiayMes extends EventoListasAsistencia {
  final String idAsignatura;
  const EliminarListasAsistenciaDiayMes({required this.idAsignatura});

  @override
  List<Object> get props => [idAsignatura];
}
