import '../../../configuracion/constantes/rutas.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

///Autor: Javier Ramos Marco
/// * Serie de pantallas de introduccion a las funcionalidades de la
/// * aplicación
///

class IntroduccionVista extends StatefulWidget {
  const IntroduccionVista({Key? key}) : super(key: key);

  @override
  State<IntroduccionVista> createState() => _IntroduccionVistaState();
}

class _IntroduccionVistaState extends State<IntroduccionVista> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "AÑADE ASIGNATURAS",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description: """Añade las asignaturas que vas a impartir indicando la
         fecha de inicio y la fecha de fin, asi como los dias en los que vas a dar clase.""",
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        pathImage: "assets/images/pupitres.png",
        backgroundColor: Colors.white,
      ),
    );

    slides.add(
      Slide(
        title: "CARGAR ALUMNOS",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Carga los alumnos de cada asignatura desde un fichero excel (.xlxs)",
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        textAlignDescription: TextAlign.center,
        pathImage: "assets/images/excel.png",
        backgroundColor: Colors.white,
      ),
    );

    slides.add(
      Slide(
        title: "PASAR LISTA",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description: "Pasa lista a tus alumnos y editalas si es necesario",
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        pathImage: "assets/images/control_de_asistencia.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "GENERA PDF",
        description: "Genera un PDF mensual con las asistencias de los alumnos",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        pathImage: "assets/images/pdf.png",
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        textAlignDescription: TextAlign.center,
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushNamed(iniciarSesionRuta);
  }

  Widget botonSiguiente() {
    return const Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget botonFinalizar() {
    return const Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget botonSaltar() {
    return const Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  ButtonStyle estiloBoton() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      renderSkipBtn: botonSaltar(),
      skipButtonStyle: estiloBoton(),

      // Next button
      renderNextBtn: botonSiguiente(),
      nextButtonStyle: estiloBoton(),

      // Done button
      renderDoneBtn: botonFinalizar(),
      onDonePress: onDonePress,
      doneButtonStyle: estiloBoton(),
    );
  }
}
