import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configuracion/configuracion.dart';
import '../../../control/bloc/autenticacion/autenticacion_bloc.dart';
import '../../../control/bloc/autenticacion/autenticacion_state.dart';
import '../../../datos/datos.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista para comprobar el estado del usuario
///

class ComprobacionAutenticacionVista extends StatelessWidget {
  const ComprobacionAutenticacionVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Mandamos un evento para comprobar si el usuario habia iniciado sesion previamente
    context.read<AutenticacionBloc>().add(
          const ComprobarEstadoUsuario(),
        );
    UsuarioAutenticado usuario;
    return MultiBlocListener(listeners: [
      BlocListener<AutenticacionBloc, EstadoAutenticacion>(
        listener: (context, state) {
          if (state is ErrorAutenticacion) {
            MiSnackBar.informacionSnackBar(context, state.mensaje);
          } else if (state is SesionIniciada) {
            usuario = state.usuarioAutenticado;
            Navigator.of(context).pushNamed(calendarioRuta, arguments: usuario);
          } else if (state is NoAutenticado) {
            Navigator.of(context).pushNamed(introduccionRuta);
          } else if (state is SinVerificarCorreo) {
            Navigator.of(context).pushNamed(verificarCorreoRuta);
          }
        },
      ),
    ], child: const PantallaCarga());
  }
}
