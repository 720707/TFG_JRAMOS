///Autor: Javier Ramos Marco
/// * Clase con las excepciones de autenticacion
///

class ExcepcionAutenticacion implements Exception {
  const ExcepcionAutenticacion();
}

class UsuarioAutenticadoNoEncontrado implements ExcepcionAutenticacion {
  const UsuarioAutenticadoNoEncontrado();
}

class PasswordIncorrecta implements ExcepcionAutenticacion {
  const PasswordIncorrecta();
}

class EmailEnUso implements ExcepcionAutenticacion {
  const EmailEnUso();
}

class EmailInvalido implements ExcepcionAutenticacion {
  const EmailInvalido();
}

//excpeciones genericas
class ExcepcionGenerica implements ExcepcionAutenticacion {
  const ExcepcionGenerica();
}

class UsuarioAutenticadoNoHaIniciadoSesion implements ExcepcionAutenticacion {
  const UsuarioAutenticadoNoHaIniciadoSesion();
}
