import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_profile_crud/components/dialog_box.dart';
import 'package:first_project_profile_crud/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  void updateUser(String userId, String newUsername, String newEmail) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': newUsername,
      'email': newEmail,
    });
  }

  void createUser(String username, String email) {
    FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
    });
  }

  void _showUpdateDialog(BuildContext context, String userId,
      String currentUsername, String currentEmail) {
    final usernameController = TextEditingController(text: currentUsername);
    final emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateUser(
                    userId, usernameController.text, emailController.text);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUserDialog(
          onCreateUser: (String username, String email) {
            createUser(
                username, email); // Call createUser when dialog is submitted
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(Icons.logout, color: Colors.white))
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Home Screen", style: TextStyle(color: Colors.white)),
      ),
      body: _fetchUser(),
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
            onPressed: _showCreateUserDialog,
            backgroundColor: Colors.black,
            child: const Text(
              "Add a User",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  Widget _fetchUser() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                final currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null && currentUser.email != data['email']) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      onLongPress: () {},
                      title: Text(data['username'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text(data['email'],
                          style: const TextStyle(fontSize: 16)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showUpdateDialog(
                                context,
                                document.id,
                                data['username'],
                                data['email'],
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteUser(document.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              });
        });
  }
}
