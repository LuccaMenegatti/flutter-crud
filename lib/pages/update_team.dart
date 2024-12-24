import 'package:flutter/material.dart';
import 'package:flutter_crud/service/database.dart';

class UpdateTeam extends StatefulWidget {
  final String teamId;
  final Map<String, dynamic> teamData;

  const UpdateTeam({super.key, required this.teamId, required this.teamData});

  @override
  State<UpdateTeam> createState() => _UpdateTeamState();
}

class _UpdateTeamState extends State<UpdateTeam> {
  late TextEditingController nameController;
  late TextEditingController foundedController;
  late TextEditingController nationalityController;
  late TextEditingController stadiumController;
  late TextEditingController coachController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.teamData["Name"]);
    foundedController = TextEditingController(text: widget.teamData["Founded"]);
    nationalityController =
        TextEditingController(text: widget.teamData["Nationality"]);
    stadiumController = TextEditingController(text: widget.teamData["Stadium"]);
    coachController = TextEditingController(text: widget.teamData["Coach"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    foundedController.dispose();
    nationalityController.dispose();
    stadiumController.dispose();
    coachController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_outlined,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "Atualizar Clube",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30.0),
              _buildTextField("Nome", nameController, "Nome do clube"),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        "Fundação", foundedController, "Fundação do clube"),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: _buildTextField("Nacionalidade",
                        nationalityController, "País sede do clube"),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        "Estádio", stadiumController, "Estádio do clube"),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: _buildTextField(
                        "Técnico", coachController, "Nome do Técnico"),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              _buildUpdateButton(),
            ],
          ),
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

  Widget _buildUpdateButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 71, 106, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty &&
              foundedController.text.isNotEmpty &&
              nationalityController.text.isNotEmpty &&
              stadiumController.text.isNotEmpty &&
              coachController.text.isNotEmpty) {
            Map<String, dynamic> updatedTeamData = {
              "Name": nameController.text,
              "Founded": foundedController.text,
              "Nationality": nationalityController.text,
              "Stadium": stadiumController.text,
              "Coach": coachController.text,
            };
            await DatabaseMethods()
                .updateTeam(updatedTeamData, widget.teamId)
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color.fromARGB(255, 61, 50, 50),
                  content: Text(
                    "Dados do clube atualizados com sucesso!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              );
              Navigator.pop(context);
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
        },
        child: const Text(
          "Atualizar Clube",
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
