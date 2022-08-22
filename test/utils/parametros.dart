import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/DTO/DTO.dart';

AlumnoDTO get alumnoDTO => AlumnoDTO(
    nipAlumno: '832332',
    nombreCompleto: 'Apellidos, Nombre',
    dniAlumno: '12392323N',
    presente: true,
    asignaturas: const ["2342342", "Matematicas"]);

AlumnoDTO get alumnoDTO2 => AlumnoDTO(
    nipAlumno: '8323656',
    nombreCompleto: 'Segundo, Tomas',
    dniAlumno: '177692323N',
    presente: false,
    asignaturas: const ["2342342", "Matematicas"]);

List<AlumnoDTO> get alumnosDTO => List.generate(
    2,
    (i) => AlumnoDTO(
        dniAlumno: '$i',
        nipAlumno: '$i',
        presente: true,
        nombreCompleto: 'Segundo, Tomas',
        asignaturas: const ["2342342", "Matematicas"]));

Alumno get alumnoEntidad => Alumno(
    dniAlumno: "12392323N",
    nipAlumno: "832332",
    nombreCompleto: 'Apellidos, Nombre',
    presente: true,
    asignaturas: const ["2342342", "Matematicas"]);

ClaseDTO get claseDTO => ClaseDTO(
    idClase: "D4433344",
    idAsignatura: "DB434443ddsa",
    idProfesor: '54454',
    nombreAsignatura: "DB",
    diaClase: DateTime.utc(2022, 8, 15),
    nombreGrado: 'Informática',
    alumnos: alumnosDTO,
    listaPasada: true);

Clase get claseEntidad => Clase(
    idClase: 'D4433344',
    idAsignatura: 'DB434443ddsa',
    idProfesor: '54454',
    nombreAsignatura: 'DB',
    diaClase: DateTime.utc(2022, 8, 15),
    nombreGrado: 'Informática',
    alumnos: const [],
    listaPasada: true);

AsignaturaDTO get asignaturaDTO => AsignaturaDTO(
    idAsignatura: "DB434443ddsa",
    idProfesor: "332323",
    nombreAsignatura: "DB",
    fechaInicio: DateTime.utc(2022, 8, 13),
    fechaFin: DateTime.utc(2022, 10, 22),
    dias: const ["lunes", "miércoles"],
    nombreGrado: 'Informática',
    idAlumnos: const ["73434", "43434"],
    listasAsistenciasMes: const []);

Asignatura get asignaturaEntidad => Asignatura(
    dias: const ["lunes", "miércoles"],
    fechaInicio: DateTime.utc(2022, 8, 13),
    fechaFin: DateTime.utc(2022, 10, 22),
    idAlumnos: const ["73434", "43434"],
    idAsignatura: "DB434443ddsa",
    idProfesor: "332323",
    listasAsistenciasMes: const [],
    nombreAsignatura: "DB",
    nombreGrado: 'Informática');

ListaAsistenciasDiaDTO get listaAsistenciasDiaDTO => ListaAsistenciasDiaDTO(
    idListaAsistenciasDia: "DB434443ddsa43344",
    idAsignatura: "DB434443ddsa",
    alumnos: alumnosDTO,
    fecha: DateTime.utc(2022, 08, 15));

List<ListaAsistenciasDiaDTO> get listasAsistenciasDiaDTO => List.generate(
    2,
    (i) => ListaAsistenciasDiaDTO(
        idListaAsistenciasDia: "$i",
        idAsignatura: "DB434443ddsa",
        alumnos: alumnosDTO,
        fecha: DateTime.utc(2022, 8, 15).add(Duration(days: i))));

ListaAsistenciasDia get listaAsistenciasDiaEntidad => ListaAsistenciasDia(
    alumnos: alumnosDTO,
    fecha: DateTime.utc(2022, 08, 15),
    idAsignatura: 'DB434443ddsa',
    idListaAsistenciasDia: 'DB434443ddsa43344');

ListaAsistenciasMesDTO get listaAsistenciasMesDTO => ListaAsistenciasMesDTO(
    idListaAsistenciasMes: "DB434443ddsa4334443dsd",
    mes: 8,
    anyo: 2022,
    idAsignatura: "DB434443ddsa",
    listaAsistenciasDia: listasAsistenciasDiaDTO);

ListaAsistenciasMes get listaAsistenciasMesEntidad => ListaAsistenciasMes(
    anyo: 2022,
    idAsignatura: "DB434443ddsa",
    idListaAsistenciasMes: "DB434443ddsa4334443dsd",
    listaAsistenciasDia: listasAsistenciasDiaDTO,
    mes: 8);

Asignatura get asignaturaSinLista => Asignatura(
    idAsignatura: '4343',
    idProfesor: '4343',
    nombreAsignatura: 'Matemáticas',
    fechaInicio: DateTime.utc(2022, 2, 2),
    fechaFin: DateTime.utc(2022, 4, 4),
    dias: const [],
    nombreGrado: 'informática',
    idAlumnos: const [],
    listasAsistenciasMes: const []);

List<ListaAsistenciasMes> get listasAsistenciasMesMock => List.generate(
    5,
    (index) => ListaAsistenciasMes(
        idListaAsistenciasMes: '$index',
        mes: 1 + index.toInt(),
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: listaAsistenciasDia));

List<ListaAsistenciasMes> get listasAsistenciasMesMock2 => List.generate(
    5,
    (index) => ListaAsistenciasMes(
        idListaAsistenciasMes: '$index',
        mes: 1 + index.toInt(),
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: listaAsistenciasDia2));

ListaAsistenciasMes get listasAsistenciasMesMockProveedores =>
    ListaAsistenciasMes(
        idListaAsistenciasMes: '20',
        mes: 3,
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: listaAsistenciasDiaProveedores);

ListaAsistenciasMes get listasAsistenciasMesMockProveedoresEditar =>
    ListaAsistenciasMes(
        idListaAsistenciasMes: '0',
        mes: 1,
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: listaAsistenciasDiaProveedores);

List<ListaAsistenciasMes> get listasAsistenciasMesMockFirebase => List.generate(
    5,
    (index) => ListaAsistenciasMes(
        idListaAsistenciasMes: '$index',
        mes: 1 + index.toInt(),
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: const []));

List<ListaAsistenciasMes> get listasAsistenciasMesParaPDF => List.generate(
    5,
    (index) => ListaAsistenciasMes(
        idListaAsistenciasMes: '$index',
        mes: 1 + index.toInt(),
        anyo: 2022,
        idAsignatura: '4343',
        listaAsistenciasDia: listaAsistenciasDiaParaPDF));

List<ListaAsistenciasDia> get listaAsistenciasDiaParaPDF => List.generate(
    5,
    (i) => ListaAsistenciasDia(
        idListaAsistenciasDia: '$i',
        idAsignatura: '$i',
        alumnos: alumnosListaCorta,
        fecha: DateTime.now().add(Duration(days: i))));

List<ListaAsistenciasDia> get listaAsistenciasDiaProveedores => List.generate(
    1,
    (i) => ListaAsistenciasDia(
        idListaAsistenciasDia: '$i',
        idAsignatura: '4343',
        alumnos: alumnos,
        fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

List<ListaAsistenciasDia>
    get listaAsistenciasDiaProveedoresEditar => List.generate(
        1,
        (i) => ListaAsistenciasDia(
            idListaAsistenciasDia: '$i',
            idAsignatura: '4343',
            alumnos: alumnos,
            fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

List<ListaAsistenciasDia> get listaAsistenciasDia => List.generate(
    5,
    (i) => ListaAsistenciasDia(
        idListaAsistenciasDia: '$i',
        idAsignatura: '4343',
        alumnos: alumnos,
        fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

List<ListaAsistenciasDia> get listaAsistenciasDiaParaProveedores =>
    List.generate(
        5,
        (i) => ListaAsistenciasDia(
            idListaAsistenciasDia: '$i',
            idAsignatura: '4343',
            alumnos: alumnos,
            fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

List<ListaAsistenciasDia> get listaAsistenciasDiaEditada => List.generate(
    5,
    (i) => ListaAsistenciasDia(
        idListaAsistenciasDia: '$i',
        idAsignatura: '4343',
        alumnos: alumnos,
        fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

List<ListaAsistenciasDia> get listaAsistenciasDia2 => List.generate(
    5,
    (i) => ListaAsistenciasDia(
        idListaAsistenciasDia: '$i',
        idAsignatura: '4343',
        alumnos: alumnos,
        fecha: DateTime.utc(2022, 1, 1).add(Duration(days: i))));

Asignatura get asignaturaConLista => Asignatura(
    idAsignatura: '4343',
    idProfesor: '4343',
    nombreAsignatura: 'Matemáticas',
    fechaInicio: DateTime.utc(2022, 2, 2),
    fechaFin: DateTime.utc(2022, 4, 4),
    dias: const [],
    nombreGrado: 'informática',
    idAlumnos: const [],
    listasAsistenciasMes: listasAsistenciasMesMock);

Asignatura get asignaturaConListaParaEditar => Asignatura(
    idAsignatura: '4343',
    idProfesor: '4343',
    nombreAsignatura: 'Matemáticas',
    fechaInicio: DateTime.utc(2022, 2, 2),
    fechaFin: DateTime.utc(2022, 4, 4),
    dias: const [],
    nombreGrado: 'informática',
    idAlumnos: const [],
    listasAsistenciasMes: listasAsistenciasMesMock2);

Asignatura get asignaturaConListaParaPDF => Asignatura(
    idAsignatura: '4343',
    idProfesor: '4343',
    nombreAsignatura: 'Matemáticas',
    fechaInicio: DateTime.now(),
    fechaFin: DateTime.now(),
    dias: const ["2", "4"],
    nombreGrado: 'informática',
    idAlumnos: const ["23", "343", "4443"],
    listasAsistenciasMes: listasAsistenciasMesParaPDF);

UsuarioAutenticado get usuario => const UsuarioAutenticado(
    email: 'preuba@gmail.com', emailVerificado: false, id: '43443');

List<Asignatura> get asignaturas => List.generate(
    16,
    (i) => Asignatura(
        idAsignatura: '$i',
        idProfesor: '4343',
        nombreAsignatura: 'Matemáticas',
        fechaInicio: DateTime.utc(2022, 1, 1).add(Duration(days: 300 * i)),
        fechaFin: DateTime.utc(2022, 2, 2),
        dias: const [],
        nombreGrado: 'informática',
        idAlumnos: const [],
        listasAsistenciasMes: listasAsistenciasMesMock));

List<Asignatura> get asignaturasTestProveedores => List.generate(
    5,
    (i) => Asignatura(
        idAsignatura: '$i',
        idProfesor: '43434',
        nombreAsignatura: 'Matemáticas',
        fechaInicio: DateTime.utc(2022, 1, 1).add(Duration(days: 300 * i)),
        fechaFin: DateTime.utc(2022, 2, 2),
        dias: const [],
        nombreGrado: 'informática',
        idAlumnos: const [],
        listasAsistenciasMes: const []));

List<Asignatura> get asignaturasMismoAnyo => List.generate(
    6,
    (i) => Asignatura(
        idAsignatura: '$i',
        idProfesor: '4343',
        nombreAsignatura: 'Matemáticas $i',
        fechaInicio: DateTime(2022),
        fechaFin: DateTime.now(),
        dias: const [],
        nombreGrado: 'informática $i',
        idAlumnos: const [],
        listasAsistenciasMes: listasAsistenciasMesMock));

Iterable<Clase> get clases => List.generate(
    4,
    (i) => Clase(
        idClase: '434',
        idAsignatura: '4343',
        idProfesor: '4334',
        nombreAsignatura: 'mates',
        diaClase: DateTime.now(),
        nombreGrado: 'Informática',
        alumnos: const [],
        listaPasada: false));

Iterable<Clase> get clasesConAlumnos => List.generate(
    4,
    (i) => Clase(
        idClase: '434',
        idAsignatura: '4343',
        idProfesor: '4334',
        nombreAsignatura: 'mates',
        diaClase: DateTime.utc(2022, 4, 5, 30, 5, 6),
        nombreGrado: 'Informática',
        alumnos: alumnos,
        listaPasada: false));

List<Alumno> get alumnos => List.generate(
    19,
    (i) => Alumno(
        nipAlumno: '$i',
        nombreCompleto: '$i',
        dniAlumno: '4334',
        presente: true));

List<Alumno> get alumnosEditados => List.generate(
    19,
    (i) => Alumno(
        nipAlumno: '$i',
        nombreCompleto: '$i',
        dniAlumno: '4334',
        presente: false));

List<Alumno> get alumnosListaCorta => List.generate(
    3,
    (i) => Alumno(
        nipAlumno: '$i',
        nombreCompleto: '$i',
        dniAlumno: '4334',
        presente: true));

Clase get clase => Clase(
    alumnos: const [],
    diaClase: DateTime.utc(2022, 2, 2),
    idClase: '45645',
    idAsignatura: '4343',
    idProfesor: '5656',
    listaPasada: false,
    nombreGrado: 'Mates',
    nombreAsignatura: 'Informática');

ListaAsistenciasDia get listaAsistenciaDia => ListaAsistenciasDia(
    alumnos: alumnos,
    fecha: DateTime.utc(2022, 4, 5, 30, 5, 6),
    idAsignatura: '554',
    idListaAsistenciasDia: '45545');

List<AlumnoPDF> get alumnosPDF => List.generate(
    5,
    (i) => AlumnoPDF(
        nipAlumno: '$i', nombreCompleto: 'Juan', asistencias: const {}));
