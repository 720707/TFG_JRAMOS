import 'package:intl/intl.dart';

import '../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Clase para crear las clases de una asignatura
///

class GeneradorClases {
  List<Clase> crearClases({
    required Asignatura asignatura,
    required List<Alumno> alumnos,
  }) {
    List<Clase> clases = [];

    var inicio = asignatura.fechaInicio;
    var fin = asignatura.fechaFin;

    var actual = inicio;

    crearClase(fin, actual, asignatura, clases, alumnos);

    return clases;
  }
}

void crearClase(DateTime fin, DateTime actual, Asignatura asignatura,
    List<Clase> eventos, List<Alumno> alumnos) {
  String diaActual = DateFormat('EEEE').format(actual);

  for (int i = 0; i < asignatura.dias.length; i++) {
    if (diaActual.compareTo(asignatura.dias[i]) == 0) {
      Clase clase = Clase(
          idClase: asignatura.idAsignatura + actual.toString(),
          idAsignatura: asignatura.idAsignatura,
          idProfesor: asignatura.idProfesor,
          nombreAsignatura: asignatura.nombreAsignatura,
          diaClase: actual,
          nombreGrado: asignatura.nombreGrado,
          alumnos: alumnos,
          listaPasada: false);

      eventos.add(clase);
    }
  }

  actual = actual.add(const Duration(days: 1));

  if (actual.isBefore(fin) || actual.isAtSameMomentAs(fin)) {
    crearClase(fin, actual, asignatura, eventos, alumnos);
  }
}
