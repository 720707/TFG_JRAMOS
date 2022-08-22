import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../configuracion/configuracion.dart';
import '../../datos/datos.dart';
import '../pantallas/pantallas.dart';

///Autor: Javier Ramos Marco
/// * Clase con las rutas de navegación y los argumentos que se les pasan
///

class GeneradorDeRutas {
  Route<dynamic> generarRuta(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case introduccionRuta:
        return MaterialPageRoute(
          builder: (_) => const IntroduccionVista(),
        );
      case comprobacionAutenticacionRuta:
        return MaterialPageRoute(
          builder: (_) => const ComprobacionAutenticacionVista(),
        );
      case iniciarSesionRuta:
        return MaterialPageRoute(
          builder: (_) => InicioSesionVista(),
        );
      case registroRuta:
        return MaterialPageRoute(
          builder: (_) => RegistroVista(),
        );
      case nuevaPasswordRuta:
        return MaterialPageRoute(
          builder: (_) => NuevaPasswordVista(),
        );
      case verificarCorreoRuta:
        return MaterialPageRoute(
          builder: (_) => const VerificacionCorreoVista(),
        );
      case calendarioRuta:
        if (args is UsuarioAutenticado) {
          UsuarioAutenticado usuario = args;
          return MaterialPageRoute(
            builder: (_) => CalendarioyClasesVista(usuario: usuario),
          );
        }
        return _rutaErronea();
      case anyadirAsignaturaRuta:
        if (args is UsuarioAutenticado) {
          UsuarioAutenticado usuario = args;
          return MaterialPageRoute(
            builder: (_) => CreacionAsignaturaVista(usuario: usuario),
          );
        }
        return _rutaErronea();

      case pasarListaClaseRuta:
        if (args is ArgumentosPantalla) {
          Clase clase = args.clase!;
          UsuarioAutenticado usuario = args.usuario;
          return MaterialPageRoute(
            builder: (_) => PasarListaEnClaseVista(
              clase: clase,
              usuario: usuario,
            ),
          );
        }
        return _rutaErronea();
      case listarAsignaturasRuta:
        if (args is UsuarioAutenticado) {
          UsuarioAutenticado usuario = args;
          return MaterialPageRoute(
            builder: (_) => ListadoAsignaturasVista(usuario: usuario),
          );
        }
        return _rutaErronea();

      case opcionesAsignaturasRuta:
        if (args is ArgumentosPantalla) {
          Asignatura asignatura = args.asignatura!;
          UsuarioAutenticado usuario = args.usuario;
          return MaterialPageRoute(
            builder: (_) => OpcionesAsignaturaVista(
              usuario: usuario,
              asignatura: asignatura,
            ),
          );
        }
        return _rutaErronea();
      case listasAsistenciasAsignaturaRuta:
        if (args is ArgumentosPantalla) {
          Asignatura asignatura = args.asignatura!;
          UsuarioAutenticado usuario = args.usuario;
          return MaterialPageRoute(
            builder: (_) => ConsultaListasAsistenciaVista(
              asignatura: asignatura,
              usuario: usuario,
            ),
          );
        }
        return _rutaErronea();
      case listaAsistenciasConcretaRuta:
        if (args is ArgumentosPantalla) {
          ListaAsistenciasDia listaAsistencias = args.listaAsistenciasDia!;
          UsuarioAutenticado usuario = args.usuario;
          Asignatura asignatura = args.asignatura!;
          if (args.editable != null) {
            return MaterialPageRoute(
              builder: (_) => ListaAsistenciaConcretaVista(
                listaAsistencias: listaAsistencias,
                usuario: usuario,
                asignatura: asignatura,
                editable: args.editable!,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => ListaAsistenciaConcretaVista(
                listaAsistencias: listaAsistencias,
                usuario: usuario,
                asignatura: asignatura,
              ),
            );
          }
        }
        return _rutaErronea();
      case listaMesesRuta:
        if (args is ArgumentosPantalla) {
          Asignatura asignatura = args.asignatura!;
          UsuarioAutenticado usuario = args.usuario;
          return MaterialPageRoute(
            builder: (_) => ConsultaListasMesesParaPdfVista(
              asignatura: asignatura,
              usuario: usuario,
            ),
          );
        }
        return _rutaErronea();

      case visorPDFRuta:
        if (args is ArgumentosPantalla) {
          Uint8List pdf = args.pdf!;
          UsuarioAutenticado usuario = args.usuario;
          Asignatura asignatura = args.asignatura!;
          ListaAsistenciasMes listaAsistenciaMes = args.listaAsistenciasMes!;
          return MaterialPageRoute(
            builder: (_) => VistaPreviaPdf(
              pdf: pdf,
              asignatura: asignatura,
              usuario: usuario,
              listaAsistencias: listaAsistenciaMes,
            ),
          );
        }
        return _rutaErronea();
      default:
        //Si indicamos una ruta que no existe
        return _rutaErronea();
    }
  }

  static Route<dynamic> _rutaErronea() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
