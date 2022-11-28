import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rostro_app/admins/am_verifyEmail.dart';
import 'package:rostro_app/models/userlogin.dart';
import '../utils/Glassmorphism.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:rostro_app/screens/login_page.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import '../utils/constant.dart';
import 'dart:io';
import '../screens/verifyEmail.dart';


class AddNewUser extends StatefulWidget {
  final String token;
 final  bool? is_superuser;
  const AddNewUser({super.key, required this.token, required this.is_superuser});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  late String token;
   var bg = './assets/images/bg6.gif';
 
  late bool? is_superuser;
    bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  void initState(){
    super.initState();
    token  = widget.token;
    print("token");
    print(token);
    is_superuser = widget.is_superuser;

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ), //background image
        child: ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            // SubmitButtonSection(context),
            submitButton(context),
            //    signUpButtonSection(),
          ],
        ),
      ),
    );
  } //build

  Container headerSection() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
        child: Image.asset(
          './assets/images/logo.jpeg',
          height: 200,
          width: 190,
          fit: BoxFit.scaleDown,
        ));
    //background im
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController departmentIdController = TextEditingController();

  var genderList = Constants.genderList;

  final List<String> roles = ['Doctor', 'Nurse', 'Physical Therapist'];
  String? selectedValueforGender;
  String? selectedValueforRoles;

  Container textSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email, color: Colors.white70),
                    hintText: 'Email',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  obscureText: !_passwordVisible1,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        // color: Theme.of(context).primaryColorDark,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible1 = !_passwordVisible1;
                        });
                      },
                    ),
                    icon: Icon(Icons.lock, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  obscureText: !_passwordVisible2,
                  keyboardType: TextInputType.text,
                  controller: cpController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        // color: Theme.of(context).primaryColorDark,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible2 = !_passwordVisible2;
                        });
                      },
                    ),
                    icon: Icon(Icons.lock, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: firstNameController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.white70),
                    hintText: 'First name',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: lastNameController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.white70),
                    hintText: 'Last name',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital, color: Colors.white70),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: const Text(
                          '     Roles',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        items: roles
                            .map((roles) => DropdownMenuItem<String>(
                                  value: roles,
                                  child: Text(
                                    roles,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValueforRoles,
                        onChanged: (value) {
                          setState(() {
                            selectedValueforRoles = value as String;
                          });
                        },
                        buttonHeight: 30,
                        buttonWidth: 200,
                        itemHeight: 30,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(236, 9, 96, 168),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: new BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: departmentIdController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.white70),
                    hintText: 'Department ID',
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white70),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: const Text(
                          '     Gender',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        items: genderList
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValueforGender,
                        onChanged: (value) {
                          setState(() {
                            selectedValueforGender = value as String;
                          });
                        },
                        buttonHeight: 30,
                        buttonWidth: 200,
                        itemHeight: 30,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(236, 9, 96, 168),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ]),
      ),
    );
  }

  Container submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 55,
        right: 55,
      ),
      child: Glassmorphism(
        blur: 20,
        opacity: 0.1,
        radius: 50.0,
        child: TextButton(
          onPressed: () async {
            String email = emailController.text;
            String password = passwordController.text;
            String cpassword = cpController.text;
  
            if (password.isNotEmpty &&
                cpassword.isNotEmpty &&
                password == cpassword) {
              UserLogin? data = await fetchDataSignUp(
                  email,
                  password,
                  firstNameController.text,
                  lastNameController.text,
                  selectedValueforRoles ?? "Nurse",
                  departmentIdController.text,
                  selectedValueforGender ?? "Male");
              print("data return");
              print(data.toString());
              if (data != null) {
                if (data.password != data.cpassword) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert Dialog Box"),
                      content: const Text("Both Password must be the same!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            color: const Color.fromARGB(236, 9, 96, 168),
                            padding: const EdgeInsets.all(14),
                            child: const Text("OK"),
                          ),
                        ),
                      ],
                    ),
                  );

               //   setState(() {});
                } else {
                  ShowDialogSucc(context);

                  setState(() {});
                }
              } else if (data == null ||
                  (password == null && cpassword == null)) {
            

                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Alert Dialog Box"),
                    content: const Text("Please Input Account Information!"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          color: const Color.fromARGB(236, 9, 96, 168),
                          padding: const EdgeInsets.all(14),
                          child: const Text("OK"),
                        ),
                      ),
                    ],
                  ),
                );

                setState(() {});
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Alert Dialog Box"),
                    content: const Text("User with this email already exists"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          color: const Color.fromARGB(236, 9, 96, 168),
                          padding: const EdgeInsets.all(14),
                          child: const Text("OK"),
                        ),
                      ),
                    ],
                  ),
                );
                setState(() {});
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            child: const Text(
              "Register with Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<UserLogin?> fetchDataSignUp(
      String email,
      String password,
      String firstName,
      String lastName,
      String role,
      String dep,
      String gender) async {
    Uri myRegUri = Uri();
    if (Constants.BASE_URL == "api.rostro-authentication.com") {
      myRegUri = Uri.https(Constants.BASE_URL, '/api/admin/users/');
    } else {
      myRegUri = Uri.parse('${Constants.BASE_URL}/api/admin/users/');
    }
    var response = await http.post(myRegUri, headers: {
      HttpHeaders.acceptHeader: 'application/json',
       HttpHeaders.authorizationHeader: 'Token $token',

    }, body: {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "role": role,
      "department_id": dep,
      "gender": gender,
    });
    var jsonResponse = null;
    var data = response.body;
  //  token = data.substring(10, data.length - 2);
    print ("data insode");
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;

    
      return albumFromJson(responseString);
    } else {
      if (response.statusCode == 400) {
        String responseString = response.body;
      }
      return null;
    }
  }

  Widget? ShowDialogSucc(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("token in verify $token");
        return AlertDialog(
          title: const Text("Message!"),
          content: const Text(
              "Your account have been created. Please check your email to verify your account."),
          actions: <Widget>[
            TextButton(
              child: const Text("Verify Email"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdminVerifyEmail(
                            email: emailController.text,
                            token: widget.token,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
