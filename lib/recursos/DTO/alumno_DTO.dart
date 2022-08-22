import '../../datos/entidades/alumno.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar Alumno con la interfaz y los repositorios
///

class AlumnoDTO extends Alumno {
  AlumnoDTO({
    required String nipAlumno,
    required String nombreCompleto,
    required String dniAlumno,
    List<String>? asignaturas,
    required bool presente,
  }) : super(
          dniAlumno: dniAlumno,
          nombreCompleto: nombreCompleto,
          nipAlumno: nipAlumno,
          asignaturas: asignaturas,
          presente: presente,
        );

  factory AlumnoDTO.fromJson(Map<String, dynamic> json) {
    return AlumnoDTO(
      nipAlumno: json["nipAlumno"] ?? "",
      nombreCompleto: json["nombreCompleto"] ?? "",
      dniAlumno: json["dniAlumno"] ?? "",
      asignaturas: (json['asignaturas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      presente: json["presente"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nipAlumno": nipAlumno,
      "nombreCompleto": nombreCompleto,
      "dniAlumno": dniAlumno,
      "asignaturas": asignaturas,
      "presente": presente,
    };
  }

  factory AlumnoDTO.fromEntity(Alumno alumnoEntidad) {
    return AlumnoDTO(
      nipAlumno: alumnoEntidad.nipAlumno,
      nombreCompleto: alumnoEntidad.nombreCompleto,
      dniAlumno: alumnoEntidad.dniAlumno,
      asignaturas: alumnoEntidad.asignaturas,
      presente: alumnoEntidad.presente,
    );
  }

  Alumno toEntity() {
    return Alumno(
      nipAlumno: nipAlumno,
      nombreCompleto: nombreCompleto,
      dniAlumno: dniAlumno,
      asignaturas: asignaturas,
      presente: presente,
    );
  }
}
