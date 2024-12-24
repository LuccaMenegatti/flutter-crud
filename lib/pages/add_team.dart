import 'package:flutter/material.dart';
import 'package:flutter_crud/service/database.dart';
import 'package:random_string/random_string.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({super.key});

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _foundedController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _stadiumController = TextEditingController();
  final TextEditingController _coachController = TextEditingController();

  void _clearFields() {
    _nameController.clear();
    _foundedController.clear();
    _nationalityController.clear();
    _stadiumController.clear();
    _coachController.clear();
  }

  Future<void> _createTeam() async {
    if (_nameController.text.isNotEmpty &&
        _foundedController.text.isNotEmpty &&
        _nationalityController.text.isNotEmpty &&
        _stadiumController.text.isNotEmpty &&
        _coachController.text.isNotEmpty) {
      String addId = randomAlphaNumeric(10);
      Map<String, dynamic> teamInfoMap = {
        "Name": _nameController.text,
        "Founded": _foundedController.text,
        "Nationality": _nationalityController.text,
        "Stadium": _stadiumController.text,
        "Coach": _coachController.text,
      };

      await DatabaseMethods().addTeam(teamInfoMap, addId).then((_) {
        _clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 61, 50, 50),
            content: Text(
              "Dados do Clube enviados com sucesso!",
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
                            "Criar Clube",
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
                    _buildTextField(
                        "Nome", _nameController, "Nome completo do Clube"),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Fundação", _foundedController,
                              "Fundação do clube"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField("Nacionalidade",
                              _nationalityController, "País sede do clube"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Estádio", _stadiumController,
                              "Estádio do clube"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField(
                              "Técnico", _coachController, "Nome do Técnico"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildCreateTeamButton(),
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

  Widget _buildCreateTeamButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 71, 106, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: _createTeam,
        child: const Text(
          "Criar Clube",
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
