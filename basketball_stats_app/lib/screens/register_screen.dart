// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrazione'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il tuo username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il tuo email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Inserisci un email valido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la tua password';
                  }
                  if (value.length < 6) {
                    return 'La password deve essere di almeno 6 caratteri';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      text: 'Registrati',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await authProvider.register(_username, _email, _password);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
