import 'package:flutter/material.dart';
import 'package:flutter_crud/pages/show_players.dart';
import 'package:flutter_crud/pages/show_teams.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CRUD Football",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      context,
                      "Jogadores",
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowPlayers()));
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _buildButton(
                      context,
                      "Clubes",
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowTeams()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              const Text(
                "Gerencie seus jogadores e times de futebol!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
