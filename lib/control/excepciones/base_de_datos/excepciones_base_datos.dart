///Autor: Javier Ramos Marco
/// * Clase con excepciones que se producen al realizar operaciones
/// * en la base de datos
///

class ExcepcionBaseDeDatos implements Exception {
  const ExcepcionBaseDeDatos();
}

class NoSePuedeCrearAlumno extends ExcepcionBaseDeDatos {
  const NoSePuedeCrearAlumno();
}

class NoSePuedeObtenerAlumno extends ExcepcionBaseDeDatos {
  const NoSePuedeObtenerAlumno();
}

class ExcepcionNoSePuedeCrearAsignatura extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeCrearAsignatura();
}

class NoSePuedeActualizarListaAsistenciaEnAsignatura
    extends ExcepcionBaseDeDatos {
  const NoSePuedeActualizarListaAsistenciaEnAsignatura();
}

class NoSePuedeEliminarListaAsistenciaEnAsignatura
    extends ExcepcionBaseDeDatos {
  const NoSePuedeEliminarListaAsistenciaEnAsignatura();
}

class NoSePuedeEditarListaAsistenciaDiaEnAsignatura
    extends ExcepcionBaseDeDatos {
  const NoSePuedeEditarListaAsistenciaDiaEnAsignatura();
}

class NoSePuedeEliminarAsignatura extends ExcepcionBaseDeDatos {
  const NoSePuedeEliminarAsignatura();
}

class NoSePuedeAnyadirAsignaturaAAlumno extends ExcepcionBaseDeDatos {
  const NoSePuedeAnyadirAsignaturaAAlumno();
}

class NoSePuedeEliminarAsignaturaAAlumno extends ExcepcionBaseDeDatos {
  const NoSePuedeEliminarAsignaturaAAlumno();
}

class ExcepcionNoSePuedeCrearClase extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeCrearClase();
}

class ExcepcionNoSePuedeObtenerClase extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeObtenerClase();
}

class ExcepcionNoSePuedeCrearListaAsistenciaDia extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeCrearListaAsistenciaDia();
}

class ExcepcionNoSePuedeCrearListaAsistenciaMes extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeCrearListaAsistenciaMes();
}

class ExcepcionNoSePuedeEliminarListaAsistenciaMes
    extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeEliminarListaAsistenciaMes();
}

class ExcepcionNoSePuedeAnyadirListaAsistenciaMes extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeAnyadirListaAsistenciaMes();
}

class ExcepcionNoSePuedeEditarListaAsistenciaDia extends ExcepcionBaseDeDatos {
  const ExcepcionNoSePuedeEditarListaAsistenciaDia();
}

class NoSePuedeEliminarListaAsistenciaDia extends ExcepcionBaseDeDatos {
  const NoSePuedeEliminarListaAsistenciaDia();
}

class NoSePuedenEliminarClases extends ExcepcionBaseDeDatos {
  const NoSePuedenEliminarClases();
}

class NoSeHaPodidoPonerListaPasadaATure extends ExcepcionBaseDeDatos {
  const NoSeHaPodidoPonerListaPasadaATure();
}

class NoSePuedeCrearListaAsistenciaDia extends ExcepcionBaseDeDatos {
  const NoSePuedeCrearListaAsistenciaDia();
}
