import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/pages/add_player.dart';
import 'package:flutter_crud/pages/update_player.dart';
import 'package:flutter_crud/service/database.dart';

class ShowPlayers extends StatefulWidget {
  const ShowPlayers({super.key});

  @override
  State<ShowPlayers> createState() => _ShowPlayersState();
}

class _ShowPlayersState extends State<ShowPlayers> {
  @override
  void initState() {
    getontheload();
    super.initState();
  }

  getontheload() async {
    playerStream = await DatabaseMethods().getPlayers();
    setState(() {});
  }

  Stream? playerStream;

  Widget showPlayersList() {
    return StreamBuilder(
      stream: playerStream,
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

                    if (ds["TeamId"] != null && ds["TeamId"].isNotEmpty) {
                      return FutureBuilder(
                        future: DatabaseMethods().getTeamById(ds["TeamId"]),
                        builder: (context, AsyncSnapshot teamSnapshot) {
                          if (!teamSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          String teamName = teamSnapshot.data["Name"];

                          return playerCard(ds, teamName);
                        },
                      );
                    } else {
                      return playerCard(ds, "Sem clube");
                    }
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget playerCard(DocumentSnapshot ds, String teamName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ds["Name"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatePlayer(
                            playerId: ds.id,
                            playerData: ds.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: ds["TeamId"] == null || ds["TeamId"].isEmpty
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar exclusão"),
                                  content: const Text(
                                      "Deseja realmente excluir o jogador?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        DatabaseMethods().deletePlayer(ds.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Excluir"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Ação inválida"),
                                  content: const Text(
                                      "Não é possível excluir o jogador enquanto ele estiver em um time."),
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
                          },
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              playerInfoRow("Idade", ds["Age"]),
              playerInfoRow("Nacionalidade", ds["Nationality"]),
              playerInfoRow("Posição", ds["Position"]),
              playerInfoRow("Numero da camisa", ds["JerseyNumber"]),
              playerInfoRow("Contrato", teamName),
            ],
          ),
        ),
      ),
    );
  }

  Widget playerInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.w500),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPlayer()));
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
                            color: Colors.white)),
                    const Spacer(),
                    const Text(
                      "Jogadores ",
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
                const SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: showPlayersList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
