// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configuracion/configuracion.dart';
import '../../../control/bloc/autenticacion/autenticacion_bloc.dart';
import '../../../datos/entidades/usuario_autenticado.dart';
import '../dialogos/dialogo_aceptar_cancelar.dart';

///Autor: Javier Ramos Marco
/// * Menu con diversas opciones
///

enum Acciones {
  cerrarSesion,
  borrarCuenta,
  mostrarAsignaturas,
  anyadirAsignatura,
}

//Menu que esta en la vista del Calendario con distintas opciones
class PopupMenuOpciones extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  const PopupMenuOpciones({required UsuarioAutenticado usuario, Key? key})
      : _usuario = usuario,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Se le pasa el enum creado previamente
    return PopupMenuButton<Acciones>(
      icon: const Icon(Icons.menu),
      onSelected: (value) async {
        switch (value) {
          case Acciones.cerrarSesion:
            final cerrarSesion = await mostrarDialogoAceptarCancelar(
                context, textoCerrarSesion, tituloCerrarSesion);

            if (cerrarSesion) {
              context.read<AutenticacionBloc>().add(
                    const CerrarSesion(),
                  );
            }
            break;
          case Acciones.borrarCuenta:
            final borrarCuenta = await mostrarDialogoAceptarCancelar(
              context,
              textoEliminarCuenta,
              tituloEliminarCuenta,
            );
            if (borrarCuenta) {
              context.read<AutenticacionBloc>().add(
                    const EliminarCuenta(),
                  );
            }
            break;
          case Acciones.mostrarAsignaturas:
            Navigator.of(context)
                .pushNamed(listarAsignaturasRuta, arguments: _usuario);

            break;
          case Acciones.anyadirAsignatura:
            Navigator.of(context)
                .pushNamed(anyadirAsignaturaRuta, arguments: _usuario);
            break;
        }
      },
      itemBuilder: (context) {
        return [
          //Cada uno de las opciones seleccionables del Menu
          const PopupMenuItem<Acciones>(
            key: Key('cerrar_sesion'),
            value: Acciones.cerrarSesion,
            child: Text(cerrarSesion),
          ),
          const PopupMenuItem<Acciones>(
            value: Acciones.borrarCuenta,
            child: Text(borrarCuenta),
          ),
          const PopupMenuItem<Acciones>(
            value: Acciones.mostrarAsignaturas,
            child: Text(mostrarAsignaturas),
          ),
          const PopupMenuItem<Acciones>(
            value: Acciones.anyadirAsignatura,
            child: Text(anyadirAsignatura),
          )
        ];
      },
    );
  }
}
