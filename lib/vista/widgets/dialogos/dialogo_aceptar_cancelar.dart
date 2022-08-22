//Funcion para mostrar una ventana emergente con la opcion de Cancelar o Aceptar
import 'package:flutter/material.dart';

///Autor: Javier Ramos Marco
/// * Widget que muestra una ventana emergente para aceptar o cancelar
///

Future<bool> mostrarDialogoAceptarCancelar(
  BuildContext context,
  String texto,
  String titulo,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Aceptar'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
