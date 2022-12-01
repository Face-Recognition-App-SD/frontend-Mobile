import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rostro_app/screens/firstpage.dart';
import 'package:rostro_app/screens/homepage.dart';
import 'package:rostro_app/screens/verify_patient.dart';
import '../screens/patient_detail.dart';
//import 'package:flutter_auth_roleperm/screens/userdetailsscreen.dart';
import '../models/PatientsData.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

class PatientListWidget extends StatefulWidget {
  final List<PatientsData> patientList;
  final String token;
  final bool isFromAll;
  final bool is_superuser;

  const PatientListWidget(
      {Key? key,
      required this.patientList,
      required this.token,
      required this.is_superuser,
      required this.isFromAll})
      : super(key: key);

  @override
  State<PatientListWidget> createState() => _PatientListWidgetState();
}

class _PatientListWidgetState extends State<PatientListWidget> {
  late String token;
  late int id;
  late bool is_superuser;

  late bool isFromAll = widget.isFromAll;
  void initState() {
    token = widget.token;
    is_superuser = widget.is_superuser;
  }

  @override
  Widget build(BuildContext context) {
    // var forecolor = backgroundColor.computeLuminance
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      itemCount: widget.patientList.isEmpty ? 0 : widget.patientList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: GlassContainer(
            borderRadius: new BorderRadius.circular(10.0),

 

            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientDetail(
                          token: token,
                          id: widget.patientList[index].id.toString(),
                          isFromALl: isFromAll, is_superuser: is_superuser)),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 48,
                  color: Colors.blueAccent,
                ),
                trailing: verify(context, index),
                title: Text(
                  widget.patientList[index].id.toString(),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Text(
                  widget.patientList[index].first_name.toString(),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget verify(context, index) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPatient(
              token: token,
              id: widget.patientList[index].id!,
              isSuperUser: is_superuser!,
            ),
          ),
        );
      },
      child: const Text('Verify Patient'),
    );
  }
}
