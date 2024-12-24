import 'package:flutter/material.dart';
import 'package:flutter_crud/service/database.dart';
import 'package:random_string/random_string.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();

  String? _selectedTeamId;
  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    DatabaseMethods().getTeams().then((teamSnapshot) {
      teamSnapshot.listen((snapshot) {
        setState(() {
          teams = snapshot.docs.map((doc) {
            return {
              'id': doc.id,
              'name': doc['Name'],
            };
          }).toList();
        });
      });
    });
  }

  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _nationalityController.clear();
    _positionController.clear();
    _jerseyNumberController.clear();
    setState(() {
      _selectedTeamId = null;
    });
  }

  Future<void> _createPlayer() async {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _nationalityController.text.isNotEmpty &&
        _positionController.text.isNotEmpty &&
        _jerseyNumberController.text.isNotEmpty) {
      String addId = randomAlphaNumeric(10);
      Map<String, dynamic> playerInfoMap = {
        "Name": _nameController.text,
        "Age": _ageController.text,
        "Nationality": _nationalityController.text,
        "Position": _positionController.text,
        "JerseyNumber": _jerseyNumberController.text,
        "TeamId": _selectedTeamId,
      };

      await DatabaseMethods().addPlayer(playerInfoMap, addId).then((_) {
        _clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 61, 50, 50),
            content: Text(
              "Dados do jogador enviados com sucesso!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Por favor, preencha todos os campos!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios_new_outlined,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text(
                            "Criar Jogador",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField("Nome Completo", _nameController,
                        "Nome completo do Jogador"),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              "Idade", _ageController, "Idade do Jogador"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField(
                              "Nacionalidade",
                              _nationalityController,
                              "Nacionalidade do Jogador"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Posição", _positionController,
                              "Posição do Jogador"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField("Número da Camisa",
                              _jerseyNumberController, "Número da Camisa"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildTeamDropdown(),
                    const SizedBox(height: 30.0),
                    _buildCreatePlayerButton(),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 61, 50, 50)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecione o Time",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: const Text(
              "Selecione um time",
              style: TextStyle(color: Color.fromARGB(255, 61, 50, 50)),
            ),
            value: _selectedTeamId,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTeamId = newValue;
              });
            },
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text(
                  "Sem time",
                  style: TextStyle(color: Color.fromARGB(255, 61, 50, 50)),
                ),
              ),
              ...teams.map<DropdownMenuItem<String>>((team) {
                return DropdownMenuItem<String>(
                  value: team['id'],
                  child: Text(
                    team['name']!,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 61, 50, 50)),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePlayerButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 71, 106, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: _createPlayer,
        child: const Text(
          "Adicionar Jogador",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
