part of 'calendario_bloc.dart';

///Autor: Javier Ramos Marco
/// * Estados del bloc CalendarioBloc
///

abstract class EstadoCalendario extends Equatable {
  const EstadoCalendario();
}

class CalendarioInitial extends EstadoCalendario {
  @override
  List<Object?> get props => [];
}

@immutable
class AsignaturasCargadas extends EstadoCalendario {
  final List<Asignatura> asignaturas;
  //Las asignaturas por defecto estan vacias
  const AsignaturasCargadas({
    this.asignaturas = const <Asignatura>[],
  });

  @override
  List<Object?> get props => [asignaturas];
}

@immutable
class ClasesCargadas extends EstadoCalendario {
  final Stream<Iterable<Clase>> clases;

  const ClasesCargadas({
    required this.clases,
  });

  @override
  List<Object?> get props => [clases];
}

@immutable
class CalendarioError extends EstadoCalendario {
  final Exception excepcion;
  final String mensaje;
  const CalendarioError({required this.excepcion, required this.mensaje});
  @override
  List<Object?> get props => [excepcion, mensaje];
}
