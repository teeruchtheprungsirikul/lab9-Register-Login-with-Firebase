import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:register_login_firebase/screen/home.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({ Key? key }) : super(key: key);
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'อีเมลของคุณคือ ' + auth.currentUser!.email.toString(),
                style:  const TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                child: const Text('ออกจากระบบ'),
                onPressed: (() {
                  Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) {
                      return const HomeScreen();
                    })
                );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}