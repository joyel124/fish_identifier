import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
  home: Home(),
  debugShowCheckedModeBanner: false,
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  XFile? image;
  String resultText = ' ';
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  Future<void> identify(XFile? imagen) async {

    if (imagen != null) {
      String url = 'http://192.168.43.246:5000/image'; // Reemplaza con la URL de tu endpoint
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath(
          'file',
          imagen.path
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResult = json.decode(responseBody);

        setState(() {
          resultText = jsonResult; // Obtén el texto devuelto del JSON recibido
        });
      } else {
        print("Connection failed with status: ${response.statusCode}");
        setState(() {
          resultText = 'Error en la solicitud';
        });
      }
    }
    else{
        notFindImage();
    }
  }

  void notFindImage(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Ingrese una Imagen'),
            content: Container(
              height: MediaQuery.of(context).size.height / 8,
              child: Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 70,
                ),
              ),
            ),
          );
        });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Por favor seleccione una opcion'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 10),
                        Text('Abrir Galeria'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        SizedBox(width: 10),
                        Text('Abrir Camara'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print(resultText);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish Identifier App'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image, you type like this.
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
              ),
            )
                : Text(
              "Seleccione una imagen",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('Subir Imagen'),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    identify(image);
                  },
                  child: Text('Clasificar'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Resultado: $resultText'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}