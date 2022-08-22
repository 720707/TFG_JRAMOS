part of 'asignatura_bloc.dart';

///Autor: Javier Ramos Marco
/// * Eventos del bloc AsignaturaBloc
///

abstract class EventoAsignatura extends Equatable {
  const EventoAsignatura();
}

class EventoAsignaturaInicializar extends EventoAsignatura {
  const EventoAsignaturaInicializar();
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando se pulsa el boton de añadir asignatura
class AnyadirAsignatura extends EventoAsignatura {
  final Asignatura asignatura;
  final List<Alumno> alumnos;

  const AnyadirAsignatura({
    required this.asignatura,
    required this.alumnos,
  });

  @override
  List<Object> get props => [alumnos, asignatura];
}

//Evento que se produce cuando se desplaza la asignatura a la derecha desde
//el listado de asignaturas
class EliminarAsignatura extends EventoAsignatura {
  final String idAsignatura;
  final String idUsuario;
  //Igual hay que cambiarlo por dia, mes, año tanto de Inicio como de Fin

  const EliminarAsignatura({
    required this.idAsignatura,
    required this.idUsuario,
  });

  @override
  List<Object> get props => [idAsignatura];
}

//Evento que se produce cuando se pulsa el boton de cargar lista de alumnos
class CargarListaAlumnos extends EventoAsignatura {
  const CargarListaAlumnos();
  @override
  List<Object> get props => [];
}

//Evento para actualizar la lista de asistencia dia en la asignatura
class ActualizarListasAsistenciaDia extends EventoAsignatura {
  final ListaAsistenciasDia listaAsistenciasDia;

  const ActualizarListasAsistenciaDia({required this.listaAsistenciasDia});

  @override
  List<Object> get props => [listaAsistenciasDia];
}

//Evento para actualizar las listas de asistencia mes
class ActualizarListasAsistenciasMes extends EventoAsignatura {
  final ListaAsistenciasMes listaAsistenciaMesSinEditar;
  final ListaAsistenciasMes listaAsistenciasMesEditada;

  const ActualizarListasAsistenciasMes(
      {required this.listaAsistenciaMesSinEditar,
      required this.listaAsistenciasMesEditada});

  @override
  List<Object> get props => [listaAsistenciaMesSinEditar];
}

//Evento para crear las clases de una asignatura
class CrearClases extends EventoAsignatura {
  final Asignatura asignatura;
  final List<Alumno> alumnos;
  const CrearClases({
    required this.asignatura,
    required this.alumnos,
  });

  @override
  List<Object> get props => [asignatura, alumnos];
}

//Evento para obtener las asignaturas del usuario
class ObtenerAsignaturas extends EventoAsignatura {
  final String idUsuario;
  const ObtenerAsignaturas({required this.idUsuario});
  @override
  List<Object> get props => [idUsuario];
}

//Evento que se produce cuando se pulsa en el boton de Generar PDF
class GenerarPDF extends EventoAsignatura {
  final ListaAsistenciasMes listaAsistenciasMes;
  final Asignatura asignatura;
  const GenerarPDF(
      {required this.listaAsistenciasMes, required this.asignatura});
  @override
  List<Object> get props => [];
}

//Evento que se produce cuando se edita una lista de asistencia
class EditarListaEnAsignatura extends EventoAsignatura {
  final ListaAsistenciasMes listaAsistenciasMesSinEditar;

  final Asignatura asignatura;

  const EditarListaEnAsignatura(
      {required this.listaAsistenciasMesSinEditar, required this.asignatura});

  @override
  List<Object> get props => [listaAsistenciasMesSinEditar, asignatura];
}
