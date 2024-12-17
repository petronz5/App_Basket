import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _email;
  String? _password;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profilo Utente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Username',
                initialValue: user?.username ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il tuo username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                initialValue: user?.email ?? '',
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
                  _email = value;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'La password deve essere di almeno 6 caratteri';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                text: 'Aggiorna Profilo',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await _apiService.updateProfile(_username, _email, _password);
                      // Aggiorna l'utente nel provider
                      await authProvider.login(_email ?? user!.email, _password ?? ''); // Aggiorna il token
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profilo aggiornato con successo')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Errore nell\'aggiornamento del profilo')),
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
