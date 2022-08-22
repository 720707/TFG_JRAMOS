import '../../datos/entidades/lista_asistencias_dia.dart';
import 'alumno_DTO.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar ListasAsistenciasDia con la interfaz y los repositorios
///

class ListaAsistenciasDiaDTO extends ListaAsistenciasDia {
  const ListaAsistenciasDiaDTO({
    required String idListaAsistenciasDia,
    required String idAsignatura,
    required List<AlumnoDTO> alumnos,
    required DateTime fecha,
  }) : super(
            alumnos: alumnos,
            idAsignatura: idAsignatura,
            idListaAsistenciasDia: idListaAsistenciasDia,
            fecha: fecha);

  factory ListaAsistenciasDiaDTO.fromJson(Map<String, dynamic> json) {
    return ListaAsistenciasDiaDTO(
      idListaAsistenciasDia: json["idListaAsistenciasDia"] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      idAsignatura: json["idAsignatura"] as String,
      alumnos: (json['alumnos'] as List<dynamic>)
          .map((e) => AlumnoDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idListaAsistenciasDia": idListaAsistenciasDia,
      "idAsignatura": idAsignatura,
      'fecha': fecha.toIso8601String(),
      'alumnos': alumnos.map((e) => AlumnoDTO.fromEntity(e).toJson()).toList(),
    };
  }

  factory ListaAsistenciasDiaDTO.fromEntity(ListaAsistenciasDia entidad) {
    return ListaAsistenciasDiaDTO(
        idListaAsistenciasDia: entidad.idListaAsistenciasDia,
        fecha: entidad.fecha,
        idAsignatura: entidad.idAsignatura,
        alumnos: entidad.alumnos.map((e) => AlumnoDTO.fromEntity(e)).toList());
  }

  ListaAsistenciasDia toEntity() {
    return ListaAsistenciasDia(
      idListaAsistenciasDia: idListaAsistenciasDia,
      fecha: fecha,
      idAsignatura: idAsignatura,
      alumnos: alumnos,
    );
  }
}
