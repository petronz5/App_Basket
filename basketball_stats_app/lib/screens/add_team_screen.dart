// lib/screens/add_team_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/team.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddTeamScreen extends StatefulWidget {
  @override
  _AddTeamScreenState createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _city = '';
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi Squadra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nome della Squadra',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il nome della squadra';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              CustomTextField(
                label: 'Città',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la città della squadra';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      text: 'Crea Squadra',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            final newTeam = await _apiService.createTeam(_name, _city);
                            Navigator.pop(context, newTeam);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Errore nella creazione della squadra: $e')),
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
