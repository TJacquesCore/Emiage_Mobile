import 'package:flutter/material.dart';

class MesCoursDemoScreen extends StatefulWidget {
  const MesCoursDemoScreen({super.key});

  @override
  State<MesCoursDemoScreen> createState() => _MesCoursDemoScreenState();
}

class _MesCoursDemoScreenState extends State<MesCoursDemoScreen> {
  final List<Map<String, dynamic>> mesCours = [
    {'nom': 'Programmation Dart', 'prof': 'Prof. Dupont', 'notes': '18/20', 'progress': 85},
    {'nom': 'Bases de données', 'prof': 'Prof. Martin', 'notes': '16/20', 'progress': 78},
    {'nom': 'Architecture Logicielle', 'prof': 'Prof. Bernard', 'notes': '17/20', 'progress': 92},
    {'nom': 'Web Development', 'prof': 'Prof. Laurent', 'notes': '19/20', 'progress': 88},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Mes Cours', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Moyenne générale', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                const Text('17.5/20', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Text('${mesCours.length} cours', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: mesCours.length,
              itemBuilder: (context, index) {
                final cours = mesCours[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => showDialog(context: context, builder: (c) => AlertDialog(title: Text(cours['nom']), content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Professeur: ${cours['prof']}'), const SizedBox(height: 10), Text('Note: ${cours['notes']}'), const SizedBox(height: 10), LinearProgressIndicator(value: (cours['progress'] as int) / 100), const SizedBox(height: 5), Text('${cours['progress']}% complété')]), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Fermer'))])),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Expanded(child: Text(cours['nom'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)), child: Text(cours['notes'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))
                            ]),
                            const SizedBox(height: 8),
                            Text(cours['prof'], style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(value: (cours['progress'] as int) / 100)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
