import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Repositories/UserClient.dart';

class AddUserPage extends StatefulWidget {
  final UserClient userClient;

  const AddUserPage({Key? key, required this.userClient}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController authLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: authLevelController,
              decoration: InputDecoration(labelText: 'Auth Level'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitUserDetails(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitUserDetails(BuildContext context) async {
    try {
      User newUser = User(
        '',
        usernameController.text,
        passwordController.text,
        emailController.text,
        authLevelController.text,
      );

      await widget.userClient.addUser(newUser);

      Navigator.pop(context);

      await widget.userClient.GetUsersAsync().then((users) {
        if (users != null) {
          setState(() {
            (context as Element).reassemble();
          });
        }
      });
    } catch (error) {
      print(error);
      return null;
    }
  }
}





