import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Clase para generar un PDF con las listas de asistencia de los alumnos
/// * en un mes concreto
///

class GeneradorPdf {
  Future<Uint8List> generarPdf(
      {required List<AlumnoPDF> alumnos,
      required ListaAsistenciasMes listaAsistencias}) async {
    final pdf = pw.Document();

    List<String> fechas = alumnos.first.asistencias.keys.toList();

    final cabecera = ['Apellidos, Nombre', 'NIP alumno', ...fechas];

    final datos = alumnos
        .map((alumno) => [
              alumno.nombreCompleto,
              alumno.nipAlumno,
              ...alumno.asistencias.values
            ])
        .toList();

    //Con Page se crea un nueva pagina del pdf
    pdf.addPage(
      pw.Page(build: (context) {
        return pw.Column(
          children: [
            pw.Text("TITULACIÓN: "),
            pw.Text("CURSO:                  ASIGNATURA:        "),
            pw.Text("DOCENTE/RESPONSABLE:"),
            pw.Table.fromTextArray(headers: cabecera, data: datos)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        );
      }),
    );
    return pdf.save();
  }

  //Metodo para crear los alumnos para el PDF
  //los alumnos tiene nombreApellidos, nip y un Map<String, List<String>> de
  //las asistencias ordenadas por dia
  List<AlumnoPDF> generarAlumnosPdf(
      {required ListaAsistenciasMes listaAsistenciasMes,
      required Asignatura asignatura}) {
    List<AlumnoPDF> alumnos = [];
    int numeroAlumnos = 0;
    List<String> nombreAlumnos = [];
    List<String> nipAlumnos = asignatura.idAlumnos;
    Map<String, List<String>> asistenciasMap = {};
    List<String> presenteAustenteDia = [];
    Map<String, String> asistenciasUsuario = {};
    String presente = "";

    //Para saber cuantos alumnos tengo para el List<AlumnoPdf> alumnos
    //Y obtengo una lista de asistencia para obtener los nombres y nips de los alumnos
    //como todas las listas de asistencia tiene todos los alumnos, con obtener una me basta
    //recorro las listas de asistencia y obtengo si el alumno esta presente o no
    for (ListaAsistenciasDia listaAsistenciasDia
        in listaAsistenciasMes.listaAsistenciasDia) {
      numeroAlumnos = listaAsistenciasDia.alumnos.length;
      for (var alumno in listaAsistenciasDia.alumnos) {
        if (alumno.presente) {
          presente = "X";
        } else {
          presente = " ";
        }
        nombreAlumnos.add(alumno.nombreCompleto);
        presenteAustenteDia.add(presente);
      }

      //Esto son las asistencias para cada lista de asistencia van con Fecha,
      //Lista asistencias
      asistenciasMap[listaAsistenciasDia.fecha.day.toString()] =
          presenteAustenteDia;
      //Borramos la lista de asistencias dia para la siguiente iteracion
      presenteAustenteDia = [];
    }

    //Lista de nombres sin repetir
    List<String> distintosNombres = [
      ...{...nombreAlumnos}
    ];

    for (int i = 0; i < numeroAlumnos; i++) {
      for (String clave in asistenciasMap.keys) {
        asistenciasUsuario[clave] = asistenciasMap[clave]!.elementAt(i);
      }
      AlumnoPDF alumno = AlumnoPDF(
          nipAlumno: nipAlumnos[i],
          nombreCompleto: distintosNombres[i],
          asistencias: asistenciasUsuario);
      alumnos.add(alumno);
      asistenciasUsuario = {};
    }

    return alumnos;
  }
}
