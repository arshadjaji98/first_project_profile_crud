import 'package:flutter/material.dart';

class CreateUserDialog extends StatefulWidget {
  final Function(String username, String email) onCreateUser;

  const CreateUserDialog({super.key, required this.onCreateUser});

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New User'),
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
            widget.onCreateUser(usernameController.text, emailController.text);
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
