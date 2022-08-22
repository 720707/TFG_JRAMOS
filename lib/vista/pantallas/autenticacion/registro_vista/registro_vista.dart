import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../widgets/widgets.dart';
import '../../pantallas.dart';

class RegistroVista extends StatelessWidget {
  RegistroVista({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final altura =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final espacio = altura > 650 ? espacioM : espacioS;
    return Scaffold(
      appBar: const MiAppBar(
        titulo: crearCuenta,
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
                SizedBox(height: 4 * espacio),
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
                CampoTextoFormulario(
                  nombreCampo: "password",
                  key: const Key('password'),
                  pista: introducirPassword,
                  icono: const Icon(Icons.password),
                  esPassword: true,
                  validador: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                    ],
                  ),
                ),
                SizedBox(height: 2 * espacio),
                CampoTextoFormulario(
                  key: const Key('password_confirmar'),
                  nombreCampo: "password_confirmar",
                  pista: confirmarPassword,
                  icono: const Icon(Icons.password),
                  esPassword: true,
                  validador: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                      (val) {
                        final password = val;
                        final passwordInicial =
                            _formKey.currentState!.fields['password']?.value;

                        if (password?.compareTo(passwordInicial) != 0) {
                          return comprobarPasswor;
                        }
                        return null;
                      }
                    ],
                  ),
                ),
                SizedBox(height: 8 * espacio),
                RegistroBoton(formKey: _formKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
