import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:register_login_firebase/model/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:register_login_firebase/screen/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Profile profile = Profile();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('สร้างบัญชี'),
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'อีเมล',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                            EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง')
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email) {
                            profile.email = email;
                          }),
                      const SizedBox(height: 15),
                      const Text(
                        'รหัสผ่าน',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator:
                            RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                        obscureText: true,
                        onSaved: (password) {
                          profile.password = password;
                        }, //ซ่อนตัวอักษร
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text(
                            'ลงทะเบียน',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                             try{
                               await FirebaseAuth.instance.
                                createUserWithEmailAndPassword(
                                  email: profile.email.toString(), 
                                  password: profile.password.toString())
                                .then((value) {
                                  formKey.currentState!.reset();
                                  Fluttertoast.showToast(msg: 'สร้างบัญชีเรียบร้อย');
                                  Navigator.pushReplacement(context, 
                                    MaterialPageRoute(builder: (context) {
                                      return const HomeScreen();
                                    })
                                  );
                                });
                               } on FirebaseAuthException catch (e) {
                                 String message;
                                 if (e.code == 'email-already-in-use') {
                                   message = 'อีเมลซ้ำไม่สามารถใช้งานได้';
                                 } else if (e.code == 'weak-password') {
                                   message = 'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
                                 } else {
                                   message = e.message.toString();
                                 }
                                Fluttertoast.showToast(msg: message);
                               }
                              
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
