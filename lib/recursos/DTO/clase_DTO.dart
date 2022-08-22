import '../../datos/entidades/clase.dart';
import '../recursos.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar Clase con la interfaz y los repositorios
///

class ClaseDTO extends Clase {
  ClaseDTO({
    required String idClase,
    required String idAsignatura,
    required String idProfesor,
    required String nombreAsignatura,
    required DateTime diaClase,
    required String nombreGrado,
    required List<AlumnoDTO> alumnos,
    required bool listaPasada,
  }) : super(
          idClase: idClase,
          diaClase: diaClase,
          idProfesor: idProfesor,
          nombreAsignatura: nombreAsignatura,
          nombreGrado: nombreGrado,
          idAsignatura: idAsignatura,
          alumnos: alumnos,
          listaPasada: listaPasada,
        );

  Map<String, dynamic> toJson() {
    return {
      'idClase': idClase,
      'idAsignatura': idAsignatura,
      'idProfesor': idProfesor,
      'nombreAsignatura': nombreAsignatura,
      'diaClase': diaClase.toIso8601String(),
      'nombreGrado': nombreGrado,
      'listaPasada': listaPasada,
      'alumnos': alumnos.map((e) => AlumnoDTO.fromEntity(e).toJson()).toList(),
    };
  }

  factory ClaseDTO.fromJson(Map<String, dynamic> json) {
    return ClaseDTO(
      idClase: json['idClase'] as String,
      idAsignatura: json['idAsignatura'] as String,
      idProfesor: json['idProfesor'] as String,
      nombreAsignatura: json['nombreAsignatura'] as String,
      diaClase: DateTime.parse(json['diaClase'] as String),
      nombreGrado: json['nombreGrado'] as String,
      listaPasada: json["listaPasada"] ?? false,
      alumnos: (json['alumnos'] as List<dynamic>)
          .map((e) => AlumnoDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory ClaseDTO.fromEntity(Clase entidad) {
    return ClaseDTO(
        idClase: entidad.idClase,
        diaClase: entidad.diaClase,
        idProfesor: entidad.idProfesor,
        nombreAsignatura: entidad.nombreAsignatura,
        nombreGrado: entidad.nombreGrado,
        idAsignatura: entidad.idAsignatura,
        listaPasada: entidad.listaPasada,
        alumnos: entidad.alumnos.map((e) => AlumnoDTO.fromEntity(e)).toList());
  }

  Clase toEntity() {
    return Clase(
      idClase: idClase,
      diaClase: diaClase,
      idProfesor: idProfesor,
      nombreAsignatura: nombreAsignatura,
      nombreGrado: nombreGrado,
      idAsignatura: idAsignatura,
      listaPasada: listaPasada,
      alumnos: alumnos,
    );
  }
}
