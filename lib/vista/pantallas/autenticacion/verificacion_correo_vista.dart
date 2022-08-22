//Widget para verificar si el usuario tiene un email valido o no
import 'package:control_asistencia_tfg_jrm/configuracion/configuracion.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista para verificar el correo
///

class VerificacionCorreoVista extends StatefulWidget {
  const VerificacionCorreoVista({Key? key}) : super(key: key);

  @override
  State<VerificacionCorreoVista> createState() =>
      _VerificacionCorreoVistaState();
}

class _VerificacionCorreoVistaState extends State<VerificacionCorreoVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MiAppBar(
        titulo: verificarEmail,
        ruta: iniciarSesionRuta,
      ),
      //Con SingleChildScroolView se hace que sea scroolable en caso de que
      //disminuya de tamaño
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Abre tu correo para confirmar la cuenta.'),
                TextButton(
                  onPressed: () async =>
                      //Se manda un email al usuario para verificar su cuenta
                      context
                          .read<AutenticacionBloc>()
                          .add(const EviarEmailVerificacion()),
                  child: const Text('Volver a enviar email de confirmación'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
