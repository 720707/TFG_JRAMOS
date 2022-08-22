part of 'asignatura_bloc.dart';

///Autor: Javier Ramos Marco
/// * Estados del bloc AsignaturaBloc
///

abstract class EstadoAsignatura extends Equatable {
  const EstadoAsignatura();
}

class AsignaturaInitial extends EstadoAsignatura {
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando se esta añadiendo una nueva asignatura
class AsignaturaAnyadida extends EstadoAsignatura {
  const AsignaturaAnyadida();
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando se esta eliminando una asignatura
class AsignaturaEliminada extends EstadoAsignatura {
  const AsignaturaEliminada();
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando se esta editando una asignatura
class AsignaturaEditada extends EstadoAsignatura {
  const AsignaturaEditada();
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando se hace alguna operacion que tarda un tiempo
class AsignaturaCargando extends EstadoAsignatura {
  const AsignaturaCargando();
  @override
  List<Object?> get props => [];
}

//Estado que se produce cuando se han cargado los alumnos desde el excel
class AlumnosCargados extends EstadoAsignatura {
  final List<Alumno> alumnos;
  const AlumnosCargados(this.alumnos);
  @override
  List<Object?> get props => [alumnos];
}

class AsignaturaCargada extends EstadoAsignatura {
  final Asignatura asignatura;
  final List<Alumno> alumnos;
  const AsignaturaCargada({required this.alumnos, required this.asignatura});
  @override
  List<Object?> get props => [asignatura, alumnos];
}

class ClasesCreadas extends EstadoAsignatura {
  const ClasesCreadas();
  @override
  List<Object?> get props => [];
}

class AsignaturaEliminadaCorrectamente extends EstadoAsignatura {
  final String idAsignatura;
  const AsignaturaEliminadaCorrectamente({required this.idAsignatura});
  @override
  List<Object?> get props => [idAsignatura];
}

@immutable
class AsignaturaError extends EstadoAsignatura {
  final Exception excepcion;
  final String mensaje;
  const AsignaturaError({required this.excepcion, required this.mensaje});
  @override
  List<Object?> get props => [excepcion, mensaje];
}

class PdfGenerado extends EstadoAsignatura {
  final Uint8List pdf;
  final ListaAsistenciasMes listaAsistenciaMes;
  const PdfGenerado({required this.pdf, required this.listaAsistenciaMes});
  @override
  List<Object?> get props => [pdf];
}

class ListaAsistenciasMesAnyadida extends EstadoAsignatura {
  const ListaAsistenciasMesAnyadida();
  @override
  List<Object?> get props => [];
}

class ListasActualizadas extends EstadoAsignatura {
  const ListasActualizadas();
  @override
  List<Object?> get props => [];
}

class AsignaturasUsuarioObtenidas extends EstadoAsignatura {
  final List<Asignatura> asignaturas;
  const AsignaturasUsuarioObtenidas({required this.asignaturas});
  @override
  List<Object?> get props => [asignaturas];
}

class ListaAsistenciasActualizada extends EstadoAsignatura {
  const ListaAsistenciasActualizada();
  @override
  List<Object?> get props => [];
}

class ListaAsistenciasEditadaEnAsignatura extends EstadoAsignatura {
  const ListaAsistenciasEditadaEnAsignatura();
  @override
  List<Object?> get props => [];
}
