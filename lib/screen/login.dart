import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the homepage widget

class loginpage extends StatelessWidget{
 final TextEditingController emailcotroller = TextEditingController(); 
 final TextEditingController passwordcotroller = TextEditingController(); 
 loginpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailcotroller,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,

            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordcotroller,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailcotroller.text;
                final password = passwordcotroller.text;
                print('login with $email, $password');
                if (email.isNotEmpty && password.isNotEmpty){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage()),
                    );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both email and password'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                // Handle login logic here
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width button
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}