import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/control/excepciones/autenticacion/excepciones_autenticacion.dart';
import 'package:control_asistencia_tfg_jrm/datos/entidades/usuario_autenticado.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockRepositorioAutenticacion mockRepositorioAutenticacion;
  late UsuarioAutenticado usuario;
  late UsuarioAutenticado usuarioSinVerificar;
  late AutenticacionBloc autenticacionBloc;
  late Exception excepcion;
  group('AutenticacionBloc test', () {
    setUp(() {
      EquatableConfig.stringify = true;
      mockRepositorioAutenticacion = MockRepositorioAutenticacion();
      usuario = const UsuarioAutenticado(
          id: '4344', email: 'prueba@gmail.com', emailVerificado: true);
      usuarioSinVerificar = const UsuarioAutenticado(
          id: '4344', email: 'prueba@gmail.com', emailVerificado: false);
      autenticacionBloc = AutenticacionBloc(
          repositorioAutenticacion: mockRepositorioAutenticacion);
      excepcion = const ExcepcionGenerica();
    });

    group('Iniciar Sesion', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioIniciadoSesion(usuario)] cuando se llama a 
        IniciarSesion y el email esta verificado''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.iniciarSesion(
              email: usuario.email,
              password: '1234')).thenAnswer((_) async => Future<void>.value);
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((invocation) => usuario);
        },
        build: () => autenticacionBloc,
        act: (bloc) =>
            bloc.add(IniciarSesion(correo: usuario.email, password: '1234')),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          SesionIniciada(usuario),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioSinVerificarCorreo] cuando se llama a 
        IniciarSesion y el email no esta verificado''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.iniciarSesion(
              email: usuario.email,
              password: '1234')).thenAnswer((_) async => Future<void>.value);
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => usuarioSinVerificar);
        },
        build: () => autenticacionBloc,
        act: (bloc) =>
            bloc.add(IniciarSesion(correo: usuario.email, password: '1234')),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          SesionIniciada(usuario),
          const SinVerificarCorreo(),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [ErrorAutenticacion] cuando se llama a 
        IniciarSesion y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.iniciarSesion(
              email: usuario.email, password: '1234')).thenThrow(excepcion);
        },
        build: () => autenticacionBloc,
        act: (bloc) =>
            bloc.add(IniciarSesion(correo: usuario.email, password: '1234')),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          ErrorAutenticacion(
              excepcion: excepcion,
              mensaje: 'Se ha producido un error, vuelve a intentarlo'),
        ],
      );
    });

    group('Comprobar Estado Usuario', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoSinAutenticar] cuando se manda el evento ComprobarEstadoUsuario
        si el usuario es null''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => null);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const ComprobarEstadoUsuario()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const NoAutenticado(),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioSinVerificarCorreo] cuando se manda el 
        evento ComprobarEstadoUsuario si el usuario no es nulo y el email 
        no esta verificado''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => usuarioSinVerificar);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const ComprobarEstadoUsuario()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const SinVerificarCorreo(),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioIniciadoSesion] cuando se manda el evento
        ComprobarEstadoUsuario si el usuario no es nulo y
        el email esta verificado''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => usuario);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const ComprobarEstadoUsuario()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          SesionIniciada(usuario),
        ],
      );
    });

    group('Iniciar Sesion Con Google', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioIniciadoSesion] cuando se manda el 
        evento IniciarSesionConGoogle''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.iniciarSesionConGoogle())
              .thenAnswer((_) async => Future<void>.value);
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => usuario);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const IniciarSesionConGoogle()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          SesionIniciada(usuario),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [ErrorAutenticacion] cuando se manda el 
        evento IniciarSesionConGoogle y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.iniciarSesionConGoogle())
              .thenThrow(excepcion);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const IniciarSesionConGoogle()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          ErrorAutenticacion(
              excepcion: excepcion,
              mensaje: 'Se ha producido un error, vuelve a intentarlo'),
        ],
      );
    });

    group('Nueva Password', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoCorreoEnviado] cuando se manda el 
        evento NuevaPassword''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.borrarCuenta(
                  email: usuario.email))
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(NuevaPassword(correo: usuario.email)),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const CorreoEnviado(),
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoAutenticacionError] cuando se manda el 
        evento NuevaPassword''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.borrarCuenta(
              email: usuario.email)).thenThrow(excepcion);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(NuevaPassword(correo: usuario.email)),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          ErrorAutenticacion(
              excepcion: excepcion,
              mensaje: 'Se ha producido un error, vuelve a intentarlo'),
        ],
      );
    });

    group('Eviar Email Verificacion', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoCargando] cuando se manda el 
        evento EnviarEmailVerificacion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.enviarEmailVerificacion())
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const EviarEmailVerificacion()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
        ],
      );
    });

    group('Registrar Usuario', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioSinVerificarCorreo] cuando se manda el 
        evento RegistrarUsuario''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.registrarUsuario(
              email: usuario.email,
              password: '1234')).thenAnswer((_) async => Future<void>.value);

          when(() => mockRepositorioAutenticacion.enviarEmailVerificacion())
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => autenticacionBloc,
        act: (bloc) =>
            bloc.add(RegistrarUsuario(password: '1234', correo: usuario.email)),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const SinVerificarCorreo()
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoAutenticacionError] cuando se manda el 
        evento RegistrarUsuario y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.registrarUsuario(
              email: usuario.email, password: '1234')).thenThrow(excepcion);
        },
        build: () => autenticacionBloc,
        act: (bloc) =>
            bloc.add(RegistrarUsuario(password: '1234', correo: usuario.email)),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          ErrorAutenticacion(
              excepcion: excepcion,
              mensaje: 'Se ha producido un error, vuelve a intentarlo')
        ],
      );
    });

    group('Cerrar Sesion', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoSinAutenticar] cuando se manda el 
        evento CerrarSesion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.cerrarSesion())
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const CerrarSesion()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const NoAutenticado()
        ],
      );
    });

    group('Eliminar Cuenta', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoSinAutenticar] cuando se manda el 
        evento EliminarCuenta''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.eliminarCuenta())
              .thenAnswer((_) async => Future<void>.value);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const EliminarCuenta()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          const NoAutenticado()
        ],
      );

      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoAutenticacionError] cuando se manda el 
        evento EliminarCuenta y se produce una excepcion''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.eliminarCuenta())
              .thenThrow(excepcion);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const EliminarCuenta()),
        expect: () => <EstadoAutenticacion>[
          const EstadoCargando(),
          ErrorAutenticacion(
              excepcion: excepcion,
              mensaje: 'Se ha producido un error, vuelve a intentarlo'),
          const NoAutenticado()
        ],
      );
    });

    group('Obtener Usuario', () {
      blocTest<AutenticacionBloc, EstadoAutenticacion>(
        '''Emite [EstadoUsuarioObtenido] cuando se manda el 
        evento ObtenerUsuario''',
        setUp: () {
          when(() => mockRepositorioAutenticacion.usuarioActual)
              .thenAnswer((_) => usuario);
        },
        build: () => autenticacionBloc,
        act: (bloc) => bloc.add(const ObtenerUsuario()),
        expect: () => <EstadoAutenticacion>[
          UsuarioObtenido(usuario: usuario),
        ],
      );
    });
  });
}
