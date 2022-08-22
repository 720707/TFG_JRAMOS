//Funcionalidad para cargar el excel y parsearlo
//Tengo que mirar que es lo que devuelve al final, si un JSON o si no devuelve nada
//Seguramente necesite el id del usuario
import 'dart:core';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Clase para procesar un fichero excel (.xlsx)
///

class ProcesadorExcel {
  Future<List<Alumno>> procesar() async {
    //Se obtiene el fichero
    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

    List<Alumno> alumnos = [];

    if (file != null && file.files.isNotEmpty) {
      var archivo = File(file.files.first.path!);
      var bytes = archivo.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      //Recorre las hojas del excel
      for (var hoja in excel.tables.keys) {
        var dniAlumno = '';
        var nipAlumno = '';
        var nombreCompleto = '';

        //Recorre las filas
        for (var fila in excel.tables[hoja]?.rows ?? []) {
          for (var celda = 0; celda < fila.length; celda++) {
            if (celda == 0) {
              nipAlumno = fila[celda]!.value.toString();
            } else if (celda == 1) {
              dniAlumno = fila[celda]!.value.toString();
            } else {
              nombreCompleto = fila[celda]!.value.toString();
            }
          }

          Alumno alumno = Alumno(
            nipAlumno: nipAlumno,
            dniAlumno: dniAlumno,
            nombreCompleto: nombreCompleto,
            presente: true,
          );
          alumnos.add(alumno);
        }
      }
      return alumnos;
    }
    return alumnos;
  }
}
