import 'package:dallumweek12/Views/AddUserPage.dart';
import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Repositories/UserClient.dart';

class UsersView extends StatefulWidget {
  final List<User> inUsers;

  const UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

class _UsersViewState extends State<UsersView> {
  final UserClient userClient = UserClient();
  late List<User> users;

  _UsersViewState(List<User> users) {
    this.users = users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("View Users"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((user) {
            return Padding(
              padding: EdgeInsets.all(3),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Username: ${user.Username}"),
                      subtitle: Text("Auth Level: ${user.AuthLevel}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('UPDATE'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('DELETE'),
                          onPressed: () => _showDeleteConfirmationDialog(user),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserPage(userClient: userClient),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(User user) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await _deleteUser(user.ID);

                await _refreshUsers();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await userClient.deleteUser(userId);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> _refreshUsers() async {
    try {
      var updatedUsers = await userClient.GetUsersAsync();
      if (updatedUsers != null) {
        setState(() {
          users = updatedUsers;
        });
      }
    } catch (error) {
      print(error);
      return null;
    }
  }
}
