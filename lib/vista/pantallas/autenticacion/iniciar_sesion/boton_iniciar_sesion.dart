import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/autenticacion/autenticacion_bloc.dart';

///Autor: Javier Ramos Marco
/// * Boton que manda evento para inciar sesion
///

class IniciarSesionBoton extends StatelessWidget {
  const IniciarSesionBoton({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<AutenticacionBloc>().add(
                  IniciarSesion(
                    correo: _formKey.currentState!.fields['correo']?.value,
                    password: _formKey.currentState!.fields['password']?.value,
                  ),
                );
            _formKey.currentState!.reset();
          }
        },
        child: const Text(iniciarSesion));
  }
}
