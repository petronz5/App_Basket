// lib/screens/add_player_screen.dart
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart'; // Importa il pacchetto country_picker
import '../services/api_service.dart';
import '../models/player.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddPlayerScreen extends StatefulWidget {
  final String teamId;

  AddPlayerScreen({required this.teamId});

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _position = '';
  int? _number;
  String? _nationality;
  int? _height;
  int? _weight;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _nationality = country.countryCode; // Salva il codice del paese
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi Giocatore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Aggiunto SingleChildScrollView per evitare overflow
            child: Column(
              children: [
                CustomTextField(
                  label: 'Nome del Giocatore',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il nome del giocatore';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Posizione',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la posizione del giocatore';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _position = value!;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Numero di Maglia',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                      return 'Inserisci un numero valido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _number = value != null && value.isNotEmpty ? int.parse(value) : null;
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectCountry,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nazionalità',
                        suffixIcon: _nationality != null
                            ? Image.network(
                          'https://flagcdn.com/w20/${_nationality!.toLowerCase()}.png',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.flag);
                          },
                        )
                            : Icon(Icons.flag),
                      ),
                      validator: (value) {
                        if (_nationality == null || _nationality!.isEmpty) {
                          return 'Seleziona la nazionalità';
                        }
                        return null;
                      },
                      initialValue: _nationality,
                      onSaved: (value) {
                        // _nationality è già impostato tramite la selezione del paese
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Altezza (cm)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                      return 'Inserisci un numero valido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _height = value != null && value.isNotEmpty ? int.parse(value) : null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Peso (kg)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                      return 'Inserisci un numero valido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weight = value != null && value.isNotEmpty ? int.parse(value) : null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                  text: 'Crea Giocatore',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      // Stampa i dati per debug
                      print({
                        'name': _name,
                        'position': _position,
                        'team': widget.teamId,
                        'number': _number,
                        'nationality': _nationality,
                        'height': _height,
                        'weight': _weight,
                      });
                      try {
                        final newPlayer = await _apiService.createPlayer(
                          _name,
                          _position,
                          widget.teamId,
                          number: _number,
                          nationality: _nationality,
                          height: _height,
                          weight: _weight,
                        );
                        Navigator.pop(context, newPlayer);
                      } catch (e) {
                        // Mostra l'errore specifico
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Errore nella creazione del giocatore: $e')),
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
      ),
    );
  }

  // Helper method to get country code from country name
  String _getCountryCode(String countryName) {
    // Utilizziamo il pacchetto country_picker per ottenere il codice del paese
    try {
      final country = Country.parse(countryName);
      return country.countryCode.toLowerCase(); // Per usare con flagcdn.com
    } catch (e) {
      return 'us'; // Default a USA se non trovato
    }
  }
}
