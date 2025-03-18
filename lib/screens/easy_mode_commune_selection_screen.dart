
import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/wine_data.dart';
import 'wine_game_screen.dart';

class EasyModeCommuneSelectionScreen extends StatelessWidget {
  const EasyModeCommuneSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Municipality> communes = getAllMunicipalities();

    return Scaffold(
      appBar: AppBar(title: const Text('Select a Commune for Easy Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: communes.map((commune) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WineGameScreen(
                        gameMode: GameMode.Easy,
                        selectedMunicipality: commune,
                      ),
                    ),
                  );
                },
                child: Text(
                  commune.displayName,
                  style: const TextStyle(color: baseColor),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}