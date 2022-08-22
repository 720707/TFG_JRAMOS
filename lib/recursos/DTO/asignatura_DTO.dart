import '../../datos/datos.dart';
import 'lista_asistencias_mes_DTO.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar Asignatura con la interfaz y los repositorios
///

class AsignaturaDTO extends Asignatura {
  const AsignaturaDTO({
    required String idAsignatura,
    required String idProfesor,
    required String nombreAsignatura,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required List<String> dias,
    required String nombreGrado,
    required List<String> idAlumnos,
    required List<ListaAsistenciasMesDTO> listasAsistenciasMes,
  }) : super(
            dias: dias,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            idProfesor: idProfesor,
            nombreAsignatura: nombreAsignatura,
            idAlumnos: idAlumnos,
            nombreGrado: nombreGrado,
            idAsignatura: idAsignatura,
            listasAsistenciasMes: listasAsistenciasMes);

  factory AsignaturaDTO.fromJson(Map<String, dynamic> json) {
    return AsignaturaDTO(
      idAsignatura: json["idAsignatura"] as String,
      idProfesor: json["idProfesor"] as String,
      nombreAsignatura: json["nombreAsignatura"] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'].toString()),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      dias: (json['dias'] as List<dynamic>).map((e) => e as String).toList(),
      nombreGrado: json["nombreGrado"] as String,
      idAlumnos:
          (json['idAlumnos'] as List<dynamic>).map((e) => e as String).toList(),
      listasAsistenciasMes: (json['listasAsistenciasMes'] as List<dynamic>)
          .map(
              (e) => ListaAsistenciasMesDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idAsignatura": idAsignatura,
      "idProfesor": idProfesor,
      "nombreAsignatura": nombreAsignatura,
      "fechaInicio": fechaInicio.toIso8601String(),
      "fechaFin": fechaFin.toIso8601String(),
      "dias": dias,
      "nombreGrado": nombreGrado,
      "idAlumnos": idAlumnos,
      'listasAsistenciasMes': listasAsistenciasMes
          .map((e) => ListaAsistenciasMesDTO.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory AsignaturaDTO.fromEntity(Asignatura entidad) {
    return AsignaturaDTO(
        dias: entidad.dias,
        fechaInicio: entidad.fechaInicio,
        fechaFin: entidad.fechaFin,
        idProfesor: entidad.idProfesor,
        nombreAsignatura: entidad.nombreAsignatura,
        idAlumnos: entidad.idAlumnos,
        nombreGrado: entidad.nombreGrado,
        idAsignatura: entidad.idAsignatura,
        listasAsistenciasMes: entidad.listasAsistenciasMes
            .map((e) => ListaAsistenciasMesDTO.fromEntity(e))
            .toList());
  }

  Asignatura toEntity() {
    return Asignatura(
        dias: dias,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        idProfesor: idProfesor,
        nombreAsignatura: nombreAsignatura,
        idAlumnos: idAlumnos,
        nombreGrado: nombreGrado,
        idAsignatura: idAsignatura,
        listasAsistenciasMes: listasAsistenciasMes);
  }
}
