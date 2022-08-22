import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../../configuracion/configuracion.dart';

///Autor: Javier Ramos Marco
/// * Widget para elegir la fecha de fin de la asignatura
///

class FechaFin extends StatelessWidget {
  const FechaFin({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
    required DateTime dActual,
  })  : _formKey = formKey,
        _dActual = dActual,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final DateTime _dActual;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: "fecha fin",
      initialValue: _dActual.add(const Duration(days: 1)),
      inputType: InputType.date,
      format: DateFormat('dd MMMM, yyyy'),
      decoration: const InputDecoration(
          border: InputBorder.none, prefixIcon: Icon(Icons.calendar_today)),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        (val) {
          final date = val;
          final fechaInicial =
              _formKey.currentState!.fields['fecha inicio']?.value;
          if (date == null) {
            return null;
          }
          if (date.isBefore(fechaInicial)) {
            return comprobarFechaFin;
          }
          return null;
        }
      ]),
    );
  }
}
