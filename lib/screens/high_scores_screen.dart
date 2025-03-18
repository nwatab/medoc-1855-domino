import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../data/wine_data.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({Key? key}) : super(key: key);

  @override
  _HighScoresScreenState createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  Map<String, int?> _bestTimes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBestTimes();
  }

  Future<void> _loadBestTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int?> times = {};
    
    // Load best times for each easy mode (one for each municipality)
    for (var municipality in getAllMunicipalities()) {
      times['easy_${municipality.name}'] = 
          prefs.getInt('best_time_easy_${municipality.name}');
    }
    
    // Load best time for standard mode
    times['standard'] = prefs.getInt('best_time_standard');
    
    setState(() {
      _bestTimes = times;
      _isLoading = false;
    });
  }

  String _formatTime(int? seconds) {
    if (seconds == null) return 'No record';
    
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Best Times',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Easy Mode Scores
                    const Text(
                      'Easy Mode',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...getAllMunicipalities().map((municipality) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(municipality.displayName),
                          trailing: Text(
                            _formatTime(_bestTimes['easy_${municipality.name}']),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 16),
                    
                    // Standard Mode Score
                    const Text(
                      'Standard Mode',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        title: const Text('All Municipalities'),
                        trailing: Text(
                          _formatTime(_bestTimes['standard']),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Reset High Scores'),
                              content: const Text('Are you sure you want to reset all high scores?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Reset all high scores
                                    for (var municipality in getAllMunicipalities()) {
                                      await prefs.remove('best_time_easy_${municipality.name}');
                                    }
                                    await prefs.remove('best_time_standard');
                                    
                                    // Reload the screen
                                    Navigator.of(context).pop();
                                    _loadBestTimes();
                                    
                                    // Show confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('All high scores have been reset'),
                                      ),
                                    );
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Reset All High Scores'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}