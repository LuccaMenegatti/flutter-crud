import 'package:flutter/material.dart';
import 'package:flutter_crud/service/database.dart';

class UpdatePlayer extends StatefulWidget {
  final String playerId;
  final Map<String, dynamic> playerData;

  const UpdatePlayer(
      {super.key, required this.playerId, required this.playerData});

  @override
  State<UpdatePlayer> createState() => _UpdatePlayerState();
}

class _UpdatePlayerState extends State<UpdatePlayer> {
  late TextEditingController namecontroller;
  late TextEditingController agecontroller;
  late TextEditingController nationalitycontroller;
  late TextEditingController positioncontroller;
  late TextEditingController jerseynumbercontroller;

  String? _selectedTeamId;
  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    super.initState();

    namecontroller = TextEditingController(text: widget.playerData['Name']);
    agecontroller = TextEditingController(text: widget.playerData['Age']);
    nationalitycontroller =
        TextEditingController(text: widget.playerData['Nationality']);
    positioncontroller =
        TextEditingController(text: widget.playerData['Position']);
    jerseynumbercontroller =
        TextEditingController(text: widget.playerData['JerseyNumber']);
    _selectedTeamId = widget.playerData['TeamId'];

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

  Future<void> _updatePlayer() async {
    Map<String, dynamic> updatedPlayer = {
      "Name": namecontroller.text,
      "Age": agecontroller.text,
      "Nationality": nationalitycontroller.text,
      "Position": positioncontroller.text,
      "JerseyNumber": jerseynumbercontroller.text,
      "TeamId": _selectedTeamId,
    };

    await DatabaseMethods()
        .updatePlayer(updatedPlayer, widget.playerId)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 61, 50, 50),
          content: Text(
            "Dados do jogador atualizados com sucesso!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
      Navigator.pop(context);
    });
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
                            "Editar Jogador",
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
                    _buildTextField("Nome Completo", namecontroller,
                        "Nome completo do Jogador"),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              "Idade", agecontroller, "Idade do Jogador"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField(
                              "Nacionalidade",
                              nationalitycontroller,
                              "Nacionalidade do Jogador"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Posição", positioncontroller,
                              "Posição do Jogador"),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: _buildTextField("Número da Camisa",
                              jerseynumbercontroller, "Número da Camisa"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildTeamDropdown(),
                    const SizedBox(height: 30.0),
                    _buildUpdatePlayerButton(),
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

  Widget _buildUpdatePlayerButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 71, 106, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: _updatePlayer,
        child: const Text(
          "Atualizar Jogador",
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
