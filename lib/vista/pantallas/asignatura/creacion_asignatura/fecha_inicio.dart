import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

///Autor: Javier Ramos Marco
/// * Widget para elegir la fecha de inicio de la asignatura
///

@immutable
class FechaInicio extends StatelessWidget {
  final DateTime dActual;

  const FechaInicio({
    Key? key,
    required this.dActual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: "fecha inicio",
      initialValue: dActual,
      inputType: InputType.date,
      format: DateFormat('dd MMMM, yyyy'),
      decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today)),
      validator: FormBuilderValidators.required(),
    );
  }
}
