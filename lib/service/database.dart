import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addPlayer(Map<String, dynamic> studentInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Players")
        .doc(id)
        .set(studentInfoMap);
  }

  Future<Stream<QuerySnapshot>> getPlayers() async {
    return FirebaseFirestore.instance.collection("Players").snapshots();
  }

  Future updatePlayer(Map<String, dynamic> updatedPlayerData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Players")
        .doc(id)
        .update(updatedPlayerData);
  }

  Future deletePlayer(String id) async {
    return await FirebaseFirestore.instance
        .collection("Players")
        .doc(id)
        .delete();
  }

  Future addTeam(Map<String, dynamic> teamInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Teams")
        .doc(id)
        .set(teamInfoMap);
  }

  Future<Stream<QuerySnapshot>> getTeams() async {
    return FirebaseFirestore.instance.collection("Teams").snapshots();
  }

  Future updateTeam(Map<String, dynamic> updatedTeamData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Teams")
        .doc(id)
        .update(updatedTeamData);
  }

  Future deleteTeam(String id) async {
    return await FirebaseFirestore.instance
        .collection("Teams")
        .doc(id)
        .delete();
  }

  Future<DocumentSnapshot> getTeamById(String teamId) async {
    return await FirebaseFirestore.instance
        .collection("Teams")
        .doc(teamId)
        .get();
  }

  Future<List<DocumentSnapshot>> getPlayersByTeamId(String teamId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Players')
        .where('TeamId', isEqualTo: teamId)
        .get();
    return snapshot.docs;
  }
}
