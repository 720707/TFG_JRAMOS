import 'package:flutter/material.dart';

import 'configuracion.dart';

///Autor: Javier Ramos Marco
/// * Fichero con las configuraciones de tema
///

var temaApp = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(240, 252, 247, 247),
    fontFamily: 'lora',
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontSize: 16, color: Colors.white),
      bodyText2: TextStyle(fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(paddingM),
      hintStyle: TextStyle(
        color: negro.withOpacity(0.5),
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: negro,
          onPrimary: blanco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(fontSize: 16)),
    ),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(99, 59, 157, 228),
      elevation: 10,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ));
