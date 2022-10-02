
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rostro_app/models/PatientsData.dart';
import '../utils/patient_list_widget.dart';


class PatientList extends StatefulWidget {
  final token;

  const PatientList({super.key, required this.token});
  State<PatientList> createState() => _PatientList();
}

class _PatientList extends State<PatientList> {
  var bg = './assets/images/bg.jpeg';
  late String token;
  late List<PatientsData> patients = [];
  @override
  void initState() {
     token = widget.token;
    super.initState();
    // initCamera(widget.patients![0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ), //background image
        child: ListView(
          children: <Widget>[
            //containers
            showPatients(),
          ],
        ),
      ),
  
    );
  }

  Container showPatients() {
    return Container(
         
        child: FutureBuilder(
          future: fetchPatients(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              http.Response resp = snapshot.data as http.Response;
              print(resp.statusCode);
              print(resp.body);
              if (resp.statusCode == 200) {
             
                final jsonMap = jsonDecode(resp.body);
                patients = (jsonMap as List)
                    .map((patientItem) => PatientsData.fromJson(patientItem))
                    .toList();
                print(patients[0].id);
                return patients.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: PatientListWidget(patientList: [],)
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No Patient found',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.171875,
                              fontSize: 24.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      );
              } else if (resp.statusCode == 401) {
    
                Future.delayed(Duration.zero, () {
                 
                });
              } else if (resp.statusCode == 403) {
               
                Future.delayed(Duration.zero, () {
                 
                });
              }
            } else if (snapshot.hasError) {
           
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${snapshot.error}'),
              ));
            }
            return const Center(
              child: Text(''''''),
            );
          },
        ),
      );
        
  }

 Future<http.Response?> fetchPatients() async {

    final response = await http.get(    
      Uri.http('192.168.1.80:8000', 'api/patients​/patientss​/'),
      
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",

        HttpHeaders.authorizationHeader: "Token " + token,
      },
    );
    // final responseJson = jsonDecode(response.body);

    return response;
  }

}
