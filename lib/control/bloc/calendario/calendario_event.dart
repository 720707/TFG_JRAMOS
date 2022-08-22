part of 'calendario_bloc.dart';

///Autor: Javier Ramos Marco
/// * Eventos del bloc CalendarioBloc
///

abstract class EventoCalendario extends Equatable {
  const EventoCalendario();
}

class CargarAsignaturas extends EventoCalendario {
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando se va al calendario para mostrar
//las clases
class CargarClasesUsuario extends EventoCalendario {
  final String idUsuario;
  const CargarClasesUsuario({required this.idUsuario});

  @override
  List<Object> get props => [idUsuario];
}
