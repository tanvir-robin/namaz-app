import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _cpassword = '';
  bool enabled = true;

  void isReady() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        print('Value become trye');
        enabled = false;
      });
    } else {
      setState(() {
        enabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    isReady();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (!(value!.contains('@'))) {
                      return 'Invalid Email';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    isReady();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be more than 6 characters';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    isReady();
                    _password = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value != _password) {
                      return 'Password didn\'t matched!';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    isReady();
                  },
                ),
                ElevatedButton(
                    onPressed: enabled
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Succes')));
                          },
                    child: const Text('Submit'))
              ],
            )),
      ),
    ));
  }
}
