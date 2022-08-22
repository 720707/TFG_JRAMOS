import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/autenticacion/autenticacion_bloc.dart';
import '../../../widgets/widgets.dart';
import '../../pantallas.dart';

///Autor: Javier Ramos Marco
/// * Vista para iniciar sesion
///

class InicioSesionVista extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  InicioSesionVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final altura =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final espacio = altura > 650 ? espacioM : espacioS;
    final esTeclado = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(iniciarSesion),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                SizedBox(height: espacio),
                if (!esTeclado)
                  Image.asset(
                    'assets/images/calendar.png',
                    width: 150,
                    height: 150,
                  ),
                SizedBox(height: espacio),
                CampoTextoFormulario(
                  pista: introducirCorreo,
                  key: const Key('correo'),
                  icono: const Icon(Icons.email),
                  nombreCampo: "correo",
                  tipoTeclado: TextInputType.emailAddress,
                  validador: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.email(),
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                SizedBox(height: espacio),
                CampoTextoFormulario(
                  pista: introducirPassword,
                  icono: const Icon(Icons.password),
                  key: const Key('password'),
                  nombreCampo: "password",
                  esPassword: true,
                  validador: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                    ],
                  ),
                ),
                SizedBox(height: 3 * espacio),
                IniciarSesionBoton(formKey: _formKey),
                SizedBox(height: espacio),
                BotonGenerico(
                  texto: iniciarSesionGoogle,
                  onPressed: () {
                    context.read<AutenticacionBloc>().add(
                          const IniciarSesionConGoogle(),
                        );
                  },
                ),
                SizedBox(height: espacio * 3),
                const BotonIrARuta(ruta: registroRuta, texto: registrarBoton),
                const BotonIrARuta(
                    ruta: nuevaPasswordRuta, texto: cambiarPassword),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
