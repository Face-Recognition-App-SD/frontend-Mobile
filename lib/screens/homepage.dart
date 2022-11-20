import 'package:flutter/material.dart';
import 'package:rostro_app/screens/Home.dart';
import 'package:rostro_app/screens/add_new_patient.dart';
import 'package:rostro_app/screens/face_compare.dart';
import 'package:rostro_app/screens/verify_patient.dart';
import './patient_list.dart';
import './get_patient_pictures.dart';
import '../utils/new_patient_widget.dart';
import './add_new_patient.dart';
import './Home.dart';
import './profile.dart';

class Homepage extends StatefulWidget {
  final String token;
  final String? firstname;
  final String? lastname;
  const Homepage({super.key, required this.token, this.firstname, this.lastname});

  @override
  State<Homepage> createState() => _homeState();
}

class _homeState extends State<Homepage> {
  static String token1 = "";
  static String firstname = "";
  static String lastname = "";
  // late String token;

  var patientPictures;
  var pages;
  void initState() {
    token1 = widget.token;
    

    print ('token in HP: $token1');
       pages = [
    Home(token: token1),
         CompareFace(token: token1),
         //GetPatientPictures(token: token1,),
         PatientList(token: token1),
         Profile(token: token1),
  ];

  }

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: pages[currentPage],

      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.add_a_photo_outlined), label: 'Recognize'),
          NavigationDestination(icon: Icon(Icons.list), label: 'My Patient List'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
            print('Token in homepage: $token1');
          });
        },
        selectedIndex: currentPage,
      ),

    );
  }

  Container welcomeContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        child: Text('tem'),
      ),
    );
  }

  Container cameraButtonSection() {
    print(token1);
    print("inside camera button");
    return Container(
        margin: const EdgeInsets.only(top: 50.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          child: const Text('Add User Pictures'),
          onPressed: () {
            patientPictures = Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GetPatientPictures(token: token1)));
          },
        )

        //end of button
        );
  }

  Container PatientListContainer() {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          child: Text('PatientList'),
          // Within the `FirstRoute` widget
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PatientList(token: token1)));
          },
        ));
  }

  Container AddNewPatientButton() {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          child: Text('Add New Patient'),
          // Within the `FirstRoute` widget
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddNewPatient(token: token1)));
          },
        ));
  }
   Container RecogPatienst() {
     return Container(
         margin: EdgeInsets.only(top: 10.0),
         padding: EdgeInsets.symmetric(horizontal: 20.0),
         child: ElevatedButton(
           child: Text('Find Patient'),
           // Within the `FirstRoute` widget
           onPressed: () async {
             Navigator.push(context,
                 MaterialPageRoute(builder: (_) => CompareFace(token: token1)));
           },
         ));
   }
}
