import '../../datos/datos.dart';
import 'lista_asistencias_dia_DTO.dart';

///Autor: Javier Ramos Marco
/// * Clase para comuniar ListasAsistenciasMes con la interfaz y los repositorios
///

class ListaAsistenciasMesDTO extends ListaAsistenciasMes {
  const ListaAsistenciasMesDTO({
    required String idListaAsistenciasMes,
    required int mes,
    required int anyo,
    required String idAsignatura,
    required List<ListaAsistenciasDiaDTO> listaAsistenciasDia,
  }) : super(
            listaAsistenciasDia: listaAsistenciasDia,
            anyo: anyo,
            idAsignatura: idAsignatura,
            idListaAsistenciasMes: idListaAsistenciasMes,
            mes: mes);

  factory ListaAsistenciasMesDTO.fromJson(Map<String, dynamic> json) {
    return ListaAsistenciasMesDTO(
      idListaAsistenciasMes: json["idListaAsistenciasMes"] as String,
      mes: json["mes"] as int,
      anyo: json["anyo"] as int,
      idAsignatura: json["idAsignatura"] as String,
      listaAsistenciasDia: (json['listaAsistenciasDia'] as List<dynamic>)
          .map(
              (e) => ListaAsistenciasDiaDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idListaAsistenciasMes": idListaAsistenciasMes,
      "mes": mes,
      "anyo": anyo,
      "idAsignatura": idAsignatura,
      'listaAsistenciasDia': listaAsistenciasDia
          .map((e) => ListaAsistenciasDiaDTO.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory ListaAsistenciasMesDTO.fromEntity(ListaAsistenciasMes entidad) {
    return ListaAsistenciasMesDTO(
        listaAsistenciasDia: entidad.listaAsistenciasDia
            .map((e) => ListaAsistenciasDiaDTO.fromEntity(e))
            .toList(),
        anyo: entidad.anyo,
        idAsignatura: entidad.idAsignatura,
        idListaAsistenciasMes: entidad.idListaAsistenciasMes,
        mes: entidad.mes);
  }

  ListaAsistenciasMes toEntity() {
    return ListaAsistenciasMes(
      listaAsistenciasDia: listaAsistenciasDia,
      anyo: anyo,
      idAsignatura: idAsignatura,
      idListaAsistenciasMes: idListaAsistenciasMes,
      mes: mes,
    );
  }
}
