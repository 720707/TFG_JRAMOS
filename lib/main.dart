import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'configuracion/configuracion.dart';
import 'control/bloc/app_bloc_observer.dart';
import 'control/bloc/asignatura/asignatura_bloc.dart';
import 'control/bloc/autenticacion/autenticacion_bloc.dart';
import 'control/bloc/calendario/calendario_bloc.dart';
import 'control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'injection.dart';
import 'recursos/recursos.dart';
import 'utilidades/crear_clases.dart';
import 'utilidades/generar_pdf.dart';
import 'utilidades/procesamiento_excel.dart';
import 'vista/rutas/generador_rutas.dart';

///Autor: Javier Ramos Marco
/// * Clase principal de la aplicación
///

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  inicializar();

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GeneradorDeRutas generadorDeRutas = GeneradorDeRutas();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AutenticacionBloc>(
          create: (context) => AutenticacionBloc(
              repositorioAutenticacion: sl<RepositorioAutenticacion>()),
        ),
        BlocProvider<CalendarioBloc>(
          create: (context) => CalendarioBloc(
            repositorioClases: sl<RepositorioClases>(),
          ),
        ),
        BlocProvider<AsignaturaBloc>(
          create: (context) => AsignaturaBloc(
            repositorioAlumnos: sl<RepositorioAlumnos>(),
            repositorioAsignaturas: sl<RepositorioAsignaturas>(),
            repositorioClases: sl<RepositorioClases>(),
            repositorioListasAsistencia: sl<RepositorioListasAsistencia>(),
            generadorClases: sl<GeneradorClases>(),
            generadorPDF: sl<GeneradorPdf>(),
            procesadorExcel: sl<ProcesadorExcel>(),
          ),
        ),
        BlocProvider<ListasAsistenciaBloc>(
          create: (context) => ListasAsistenciaBloc(
            repositorioListasAsistencia: sl<RepositorioListasAsistencia>(),
            repositorioClases: sl<RepositorioClases>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: tituloAplicacion,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        //Quitar la marca de Debug
        debugShowCheckedModeBanner: false,
        theme: temaApp,
        darkTheme: ThemeData.dark(),
        //La ruta por defecto es la que se ha declarado con '/'
        onGenerateRoute: generadorDeRutas.generarRuta,
      ),
    );
  }
}
