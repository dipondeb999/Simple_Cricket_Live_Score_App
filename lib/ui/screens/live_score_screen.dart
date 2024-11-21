import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:score_app/data/models/cricket_score.dart';

class LiveScoreScreen extends StatefulWidget {
  const LiveScoreScreen({super.key});

  @override
  State<LiveScoreScreen> createState() => _LiveScoreScreenState();
}

class _LiveScoreScreenState extends State<LiveScoreScreen> {

  final List<CricketScore> _cricketScoreList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Live Scores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cricket').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {

              _extractData(snapshot.data);

              return ListView.builder(
                itemCount: _cricketScoreList.length,
                itemBuilder: (context, index) {
                  CricketScore cricketScore = _cricketScoreList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _indicatorColor(cricketScore.isMatchRunning),
                        radius: 8,
                      ),
                      title: Text(cricketScore.matchId),
                      subtitle: Text('Team 1 : ${cricketScore.teamOne}\nTeam 2 : ${cricketScore.teamTwo}\nwinner : ${cricketScore.winnerTeam == '' ? 'Pending' : cricketScore.winnerTeam}'),
                      trailing: Text('${cricketScore.teamOneScore}/${cricketScore.teamTwoScore}'),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CricketScore cricketScore = CricketScore(
            matchId: 'indvsaus',
              teamOne: 'India',
              teamTwo: 'Australia',
              teamOneScore: 0,
              teamTwoScore: 400,
              isMatchRunning: true,
              winnerTeam: '',
          );
          
          FirebaseFirestore.instance.collection('cricket').doc(cricketScore.matchId).update(cricketScore.toJson());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _indicatorColor(bool isMatchRunning) {
    return isMatchRunning ? Colors.green : Colors.grey;
  }

  void _extractData(QuerySnapshot<Map<String, dynamic>>? snapshot) {
    _cricketScoreList.clear();
    for (DocumentSnapshot doc in snapshot?.docs ?? []) {
      _cricketScoreList.add(CricketScore.fromJson(doc.id, doc.data() as Map<String, dynamic>));
    }
  }
}
