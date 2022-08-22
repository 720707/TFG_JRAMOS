part of 'listas_asistencia_bloc.dart';

///Autor: Javier Ramos Marco
/// * Estados del bloc ListasAsistenciasBloc
///

abstract class EstadoListasAsistencia extends Equatable {
  const EstadoListasAsistencia();
}

class ListasAsistenciaInitial extends EstadoListasAsistencia {
  @override
  List<Object> get props => [];
}

@immutable
class ListasAsistenciasError extends EstadoListasAsistencia {
  final Exception excepcion;
  const ListasAsistenciasError({required this.excepcion});
  @override
  List<Object> get props => [excepcion];
}

class ListasAsistenciasMesObtenidas extends EstadoListasAsistencia {
  final List<ListaAsistenciasMes> listasAsistenciasMes;
  const ListasAsistenciasMesObtenidas({required this.listasAsistenciasMes});
  @override
  List<Object> get props => [listasAsistenciasMes];
}

class ListaAsistenciasDiaPasada extends EstadoListasAsistencia {
  final ListaAsistenciasDia listaAsistenciaDia;
  const ListaAsistenciasDiaPasada(this.listaAsistenciaDia);
  @override
  List<Object> get props => [listaAsistenciaDia];
}

//Estado que se produce cuando se hace alguna operacion que tarda un tiempo
class ListasAsistenciaCargando extends EstadoListasAsistencia {
  const ListasAsistenciaCargando();

  @override
  List<Object> get props => [];
}

class ListasAsistenciaEliminadas extends EstadoListasAsistencia {
  const ListasAsistenciaEliminadas();

  @override
  List<Object> get props => [];
}

class ListaAsistenciasEditada extends EstadoListasAsistencia {
  final ListaAsistenciasMes listaAsistenciasMesSinEditar;
  const ListaAsistenciasEditada({required this.listaAsistenciasMesSinEditar});

  @override
  List<Object> get props => [listaAsistenciasMesSinEditar];
}
