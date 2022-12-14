import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rostro_app/screens/show_patient.dart';
import '../utils/constant.dart';
import './camera.dart';

class CompareFace extends StatefulWidget {
  final String token;

  const CompareFace({super.key, required this.token});

  @override
  State<CompareFace> createState() => ExtendedCompareFace();
}

class ExtendedCompareFace extends State<CompareFace> {
  var bg = './assets/images/bg.jpeg';
  late String token;
  late Map<String, dynamic> pictures;
  late int id;
  XFile? picture;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Identify Patient"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ), //background image
        child: ListView(
          children: <Widget>[
            cameraButtonSection(),
          ],
        ),
      ),
    );
  }

  Container cameraButtonSection() {
    id = 1;
    return Container(
        margin: const EdgeInsets.only(top: 50.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          child: const Text('Take Picture of Patient'),
          onPressed: () async {
            Uri faceCompareUri = Uri();
            if(Constants.BASE_URL == "api.rostro-authentication.com"){
              faceCompareUri = Uri.https(Constants.BASE_URL, '/api/user/faceCompare/');
            }
            else{
              faceCompareUri = Uri.parse("${Constants.BASE_URL}/api/user/faceCompare/");
            }
            picture = await availableCameras().then((value) =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Camera(token: token, cameras: value))));

            if (picture == null) return;
            String path = picture!.path;
            var request = http.MultipartRequest("POST", faceCompareUri);
            request.headers.addAll({"Authorization": "Token $token"});

            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });

            var image = await http.MultipartFile.fromPath("image1", path);
            request.files.add(image);
            http.StreamedResponse response = await request.send();
            var responseData = await response.stream.toBytes();
            var responseString = String.fromCharCodes(responseData);
            var respues = jsonDecode(responseString);

            Navigator.of(context).pop();
            if (respues['T'] == '-1' || respues['T'] == 'Not Found') {
              const snackbar = SnackBar(
                  content: Text(
                    "No Match",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            else {
              id = int.parse(respues['T'].toString());
              Uri getPatientUri = Uri();
              if(Constants.BASE_URL == "api.rostro-authentication.com"){
                getPatientUri = Uri.https(Constants.BASE_URL, '/api/patients/patientss/$id/');
              }
              else{
                getPatientUri = Uri.parse('${Constants.BASE_URL}/api/patients/patientss/$id/');
              }
              Uri getImagesUri = Uri();
              if(Constants.BASE_URL == "api.rostro-authentication.com"){
                getImagesUri = Uri.https(Constants.BASE_URL, '/api/patients/all/$id/get_images/');
              }
              else{
                getImagesUri = Uri.parse('${Constants.BASE_URL}/api/patients/all/$id/get_images/');
              }
              final imageRes = await http.get(
                getImagesUri,
                headers: {
                  HttpHeaders.acceptHeader: 'application/json',
                  HttpHeaders.authorizationHeader: 'Token $token',
                },
              );
              final patientRes = await http.get(
                getPatientUri,
                headers: {
                  HttpHeaders.acceptHeader: 'application/json',
                  HttpHeaders.authorizationHeader: 'Token $token',
                },
              );
              var decodedPatient = jsonDecode(patientRes.body);
              pictures = json.decode(imageRes.body);
              XFile retrievedPicture = XFile(pictures['image_lists'][0]['image']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ShowPatient(
                              token: token,
                              details: decodedPatient,
                              picture: retrievedPicture,
                              isFromAll: true,)));
            }
          }
        )//end of button
        );
  }
}

