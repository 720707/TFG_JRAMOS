import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/autenticacion/autenticacion_bloc.dart';
import '../../../../control/bloc/autenticacion/autenticacion_state.dart';
import '../../../widgets/widgets.dart';
import '../../pantallas.dart';

///Autor: Javier Ramos Marco
/// * Vista para obtener una nueva contraseña
///

class NuevaPasswordVista extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  NuevaPasswordVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final altura =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final espacio = altura > 650 ? espacioM : espacioS;
    return BlocListener<AutenticacionBloc, EstadoAutenticacion>(
      listener: (context, state) {
        if (state is CorreoEnviado) {
          MiSnackBar.informacionSnackBar(context, textoCorreoEnviado);
        }
      },
      child: Scaffold(
        appBar: const MiAppBar(
          titulo: cambiarPasswordTitulo,
          ruta: iniciarSesionRuta,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 2 * espacio),
                  CampoTextoFormulario(
                    pista: introducirCorreo,
                    icono: const Icon(Icons.email),
                    key: const Key('correo'),
                    nombreCampo: "correo",
                    tipoTeclado: TextInputType.emailAddress,
                    validador: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                  SizedBox(height: 2 * espacio),
                  NuevaPasswordBoton(formKey: _formKey),
                  SizedBox(height: 2 * espacio),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
