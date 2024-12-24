import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/pages/add_team.dart';
import 'package:flutter_crud/pages/update_team.dart';
import 'package:flutter_crud/service/database.dart';

class ShowTeams extends StatefulWidget {
  const ShowTeams({super.key});

  @override
  State<ShowTeams> createState() => _ShowTeamsState();
}

class _ShowTeamsState extends State<ShowTeams> {
  @override
  void initState() {
    getontheload();
    super.initState();
  }

  getontheload() async {
    teamStream = await DatabaseMethods().getTeams();
    setState(() {});
  }

  Stream? teamStream;

  Widget showTeamList() {
    return StreamBuilder(
      stream: teamStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return teamCard(ds);
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget teamCard(DocumentSnapshot ds) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ds["Name"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTeam(
                            teamId: ds.id,
                            teamData: ds.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () async {
                      List<DocumentSnapshot> players =
                          await DatabaseMethods().getPlayersByTeamId(ds.id);

                      if (players.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Erro"),
                              content: const Text(
                                  "Este time possui jogadores vinculados e não pode ser excluído."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar exclusão"),
                              content: const Text(
                                  "Deseja realmente excluir o clube?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    DatabaseMethods().deleteTeam(ds.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Excluir"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              teamInfoRow("Fundação", ds["Founded"]),
              teamInfoRow("Nacionalidade", ds["Nationality"]),
              teamInfoRow("Estádio", ds["Stadium"]),
              teamInfoRow("Técnico", ds["Coach"]),
              const SizedBox(height: 15.0),
              const Text(
                "Elenco:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<List<DocumentSnapshot>>(
                future: DatabaseMethods().getPlayersByTeamId(ds.id),
                builder: (context,
                    AsyncSnapshot<List<DocumentSnapshot>> playerSnapshot) {
                  if (!playerSnapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  List<DocumentSnapshot> players = playerSnapshot.data!;
                  if (players.isEmpty) {
                    return const Text("Nenhum jogador no elenco.");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: players.map((player) {
                      return Text(
                        player["Name"],
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16.0),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(66, 71, 106, 1.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeam()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: SafeArea(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
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
                    const Spacer(),
                    const Text(
                      "Clubes ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Cadastrados",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30.0),
                Expanded(
                  child: showTeamList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
