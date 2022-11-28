import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rostro_app/admins/am_userlist.dart';
import 'package:rostro_app/screens/firstpage.dart';
import 'package:rostro_app/screens/login_page.dart';
import 'package:rostro_app/screens/pwdchange.dart';
import '../utils/constant.dart';
import '../models/userlogin.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import '../utils/Glassmorphism.dart';
import 'package:camera/camera.dart';
import '../screens/get_patient_pictures.dart';
List<String> genders = <String>[
  'Please select role',
  'Male',
  'Female',
  'Transgender',
  'Non-binary/non-conforming',
  'Prefer not to respond'
];
 List<String> roles = ['Please select role', 'Doctor', 'Nurse', 'Physical Therapist'];
String genero = 'none';
String roleo = 'none';

class EditUser extends StatefulWidget {
   final Future<UserLogin?> futureUser;
  final String token;
  final id;
  const EditUser({super.key, required this.token, required this.id, required this.futureUser});

  @override
  State<EditUser> createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  
  var bg = './assets/images/bg6.gif';
  late String token;
  late int? id;
  late Future<UserLogin?> futureUser;


  @override
  void initState() {
    super.initState();
    token = widget.token;
    id = widget.id;
    futureUser = widget.futureUser;
   
  }

  int currentPage = 0;
  String? email = "";
  String? firstName = "";
  String? lastName = "";
  String? role = "";
  String? gender = "";
  bool? is_superuser = false;




  List<XFile?> pictures = [];
  // TextEditingController idController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController department_idController = TextEditingController();
  TextEditingController genderController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
         Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  {
                    delete(id!, token);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UserList(
                                token: token,
                              )),
                    );
                  }
                },
              
              
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                
              ),
            ),
        ],
      ),
      body:  Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bg),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(), //background image
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const SizedBox(height: 10.0),
               FutureBuilder<UserLogin?>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              id = snapshot.data!.id;
              emailController.text = snapshot.data!.email ?? "Not provided";
              firstnameController.text = snapshot.data!.first_name ?? "Not provided";
            lastnameController.text= snapshot.data!.last_name ?? "Not provided";
           
              roleController.text = snapshot.data!.role ?? "Not provided";
              department_idController.text = snapshot.data!.department_id.toString();
              gender = snapshot.data!.gender;
              
          }
          return textData(context);},),
            


            //    getImages(context),
                submitButton(context),
              ],
            ),
          ),
        ));
  }

 delete(int id, String token) async {
    var rest = await deleteUser(id, token);
    setState(() {});
  }


  // Widget getImages(BuildContext context) {
  //   return Container(
  //       margin: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
  //       child: Glassmorphism(
  //           blur: 20,
  //           opacity: 0.1,
  //           radius: 50.0,
  //           child:
  //               // padding: const EdgeInsets.symmetric(horizontal: 20.0),

  //               TextButton(
  //             // child: const Text('Update Images'),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(
  //                 vertical: 5,
  //                 horizontal: 5,
  //               ),
  //               child: const Text("Update Image",
  //                   style: TextStyle(color: Colors.white, fontSize: 13.0)),
  //             ),
  //             onPressed: () async {
  //               pictures = await Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) =>
  //                           GetPatientPictures(token: token)));
  //             },
  //           )));
  // }

  Future<bool> editPatientInfo() async {
    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
   
    print(genero);
    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
    Uri addPatientTextUri = Uri();
    if (Constants.BASE_URL == "api.rostro-authentication.com") {
      addPatientTextUri =
          Uri.https(Constants.BASE_URL, '/api/admin/users/$id/');
    } else {
      addPatientTextUri =
          Uri.parse("${Constants.BASE_URL}/api/admin/users/$id/");
    }
    bool flag = false;
    if (firstnameController.text.isNotEmpty) {
      editPatient(addPatientTextUri, 'first_name', firstnameController.text);
      flag = true;
    }
    if (lastnameController.text.isNotEmpty) {
      editPatient(addPatientTextUri, 'last_name', lastnameController.text);
      flag = true;
    }
    if (emailController.text.isNotEmpty) {
      editPatient(addPatientTextUri, 'email', emailController.text);
      flag = true;
    }
    if (roleController.text.isNotEmpty) {
      editPatient(addPatientTextUri, 'role', roleController.text);
      flag = true;
    }
     if (department_idController.text.isNotEmpty) {
      editPatient(addPatientTextUri, 'department_id', department_idController.text);
      flag = true;
    }
   
    if (genero != 'none') {
      editPatient(addPatientTextUri, 'gender', genero);
      flag = true;
    }
    return flag;
  }

  Future<UserList?> editPatient(addPatientTextUri, key, val) async {
    if (key == "gender") {
      print("JOIJOJIOJOIJOIJS");
      print(genero);
    
      print(key + "======" + val);
    }
    final res = await http.patch(addPatientTextUri, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Token $token',
    }, body: {
      key: val,
    });

  }

  // Future<bool> updateImages() async {
  //   if (pictures.isNotEmpty) {
  //     Uri addPatientPictures = Uri();
  //     if (Constants.BASE_URL == "api.rostro-authentication.com") {
  //       addPatientPictures = Uri.https(
  //           Constants.BASE_URL, '/api/patients/patientss/$id/upload-image/');
            
  //     } else {
  //       addPatientPictures = Uri.parse(
  //           "${Constants.BASE_URL}/api/patients/patientss/$id/upload-image/");
  //     }
  //     var request = http.MultipartRequest("POST", addPatientPictures);
  //     request.headers.addAll({"Authorization": "Token $token"});
  //     request.fields['id'] = id.toString();
  //     var image1 =

  //         await http.MultipartFile.fromPath("image_lists", pictures[0]!.path);
  //     request.files.add(image1);
  //     var image2 =
  //         await http.MultipartFile.fromPath("image_lists", pictures[1]!.path);
  //     request.files.add(image2);
  //     var image3 =
  //         await http.MultipartFile.fromPath("image_lists", pictures[2]!.path);
  //     request.files.add(image3);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode > 199 && response.statusCode < 300) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }


  Widget textData(context) {
    

    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          //     Container(
          //    
            
              GlassContainer(
                borderRadius: new BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Firstname:",
                          // textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        controller: firstnameController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.white70),
                          // hintText: 'DepartID',
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GlassContainer(
                borderRadius: new BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "\t Lastname:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        controller: lastnameController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.white70),
                          // hintText: 'DepartID',
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GlassContainer(
                borderRadius: new BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "\t Email:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.white70),
                          // hintText: 'DepartID',
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
             GlassContainer(
                  width: double.infinity,
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                        children: const <Widget>[
                          SizedBox(height: 20.0),
                          Text(
                            "\t Role:",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          DropDownRole(),
                        ],
                      ))),
              const SizedBox(height: 20.0),
              GlassContainer(
                borderRadius: new BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "\t Department_id:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        controller: department_idController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.local_hospital_outlined,
                              color: Colors.white70),
                          // hintText: 'DepartID',
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GlassContainer(
                  width: double.infinity,
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                        children: const <Widget>[
                          SizedBox(height: 20.0),
                          Text(
                            "\t Gender:",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          DropDownGender(),
                        ],
                      )))
            ]));
  }

  Widget? _showDialog(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message!!"),
          content:
              const Text("Patient information has been edited successfully!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserList(
                            token: token,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget submitButton(BuildContext context) {
    var resPics = false;
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        child: const Text('Submit'),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
          var resText = await editPatientInfo();
          // if (pictures.isNotEmpty) {
          //   resPics = await updateImages();
          // }
          Navigator.of(context).pop();
          if (resText || resPics) {
            _showDialog(context, token);
          }
        },
      ),
    );
  }

  Future <http.Response> deleteUser(int id, String token) async {
      Uri deleteUri = Uri();
      if(Constants.BASE_URL == "api.rostro-authentication.com"){
        deleteUri = Uri.https(Constants.BASE_URL,'/api/admin/users/$id/');
      }
      else{
        deleteUri = Uri.parse('${Constants.BASE_URL}/api/admin/users/$id/');
      }
    var response = await http.delete(deleteUri,

    headers: 
    {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Token $token',
      },
     );
    if(response.statusCode > 200 && response.statusCode < 300){
      setState(() {
        
      });
      return response;
    
    }else{throw "Sorry! Unable to delete this post";}
  }

 

}

class DropDownGender extends StatefulWidget {
  const DropDownGender({super.key});

  State<DropDownGender> createState() => _DropDownGender();
}

class _DropDownGender extends State<DropDownGender> {
  String gender = genders.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: gender,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          gender = value!;
          genero = value;
        });
      },
      items: genders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          alignment: Alignment.centerRight,
        );
      }).toList(),
    );
  }

}
  
class DropDownRole extends StatefulWidget {
  const DropDownRole({super.key});

  State<DropDownRole> createState() => _DropDownRole();
}

class _DropDownRole extends State<DropDownRole> {
  String role =  roles.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: role,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          role = value!;
          roleo = value;
        });
      },
      items: roles.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          alignment: Alignment.centerRight,
        );
      }).toList(),
    );
  }

}
  