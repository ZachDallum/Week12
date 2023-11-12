import 'package:dallumweek12/Models/LoginStructure.dart';
import 'package:flutter/material.dart';

import 'Models/AuthResponse.dart';
import 'Models/User.dart';
import 'Repositories/UserClient.dart';
import 'Views/userViews.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Dallum Week 12'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final UserClient userClient = UserClient();

  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool _loading = false;

class _MyHomePageState extends State<MyHomePage> {
  var apiVersion = "";

  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();
  void initState() {
    super.initState();
    _loading = true;
    widget.userClient
        .GetApiVersion()
        .then((response) => {setApiVersion(response)});
  }

  void setApiVersion(String version) {
    setState(() {
      apiVersion = version;
      _loading = false;
    });
  }

  void onLoginButtonPress() {
    setState(() {
      _loading = true;
      LoginStructure user =
          new LoginStructure(usernameController.text, passwordController.text);
      widget.userClient
          .Login(user)
          .then((response) => {onLoginSuccess(response)});
    });
  }

  void onLoginSuccess(var response) {
    if (response == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failure")));
    } else {
      if (response is AuthResponse) {
        getUsers();
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void getUsers() {
    setState(() {
      _loading = true;
      widget.userClient
          .GetUsersAsync()
          .then((response) => {onGetUsersSuccess(response)});
    });
  }

  void onGetUsersSuccess(List<User>? users) {
    setState(() {
      if (users != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => UsersView(inUsers: users))));
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Enter Credentials"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(hintText: "Username"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onLoginButtonPress,
                      child: Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
            _loading
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("Loading"),
                    ],
                  )
                : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text(apiVersion)],
            ),
          ],
        ),
      ),
    );
  }
}
