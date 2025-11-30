import 'package:flutter/material.dart';

class PlanningDemoScreen extends StatefulWidget {
  const PlanningDemoScreen({super.key});

  @override
  State<PlanningDemoScreen> createState() => _PlanningDemoScreenState();
}

class _PlanningDemoScreenState extends State<PlanningDemoScreen> {
  String _selectedDay = 'Tous';
  
  final List<Map<String, dynamic>> planning = [
    {'cours': 'Algo & Structures', 'jour': 'Lundi', 'heure': '08:00-09:30', 'salle': 'A101', 'prof': 'Prof. Dupont'},
    {'cours': 'Programmation Dart', 'jour': 'Lundi', 'heure': '10:00-11:30', 'salle': 'A102', 'prof': 'Prof. Dupont'},
    {'cours': 'Bases de Données', 'jour': 'Mardi', 'heure': '14:00-15:30', 'salle': 'B205', 'prof': 'Prof. Martin'},
    {'cours': 'Web Dev', 'jour': 'Mercredi', 'heure': '09:00-10:30', 'salle': 'C310', 'prof': 'Prof. Laurent'},
    {'cours': 'Architecture', 'jour': 'Mercredi', 'heure': '14:00-15:30', 'salle': 'C311', 'prof': 'Prof. Bernard'},
    {'cours': 'Réseaux', 'jour': 'Jeudi', 'heure': '10:00-11:30', 'salle': 'D405', 'prof': 'Prof. Marchand'},
    {'cours': 'TP Projet', 'jour': 'Vendredi', 'heure': '13:30-15:30', 'salle': 'Lab301', 'prof': 'Prof. Durand'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedDay == 'Tous' ? planning : planning.where((p) => p['jour'] == _selectedDay).toList();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Emploi du Temps', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              children: ['Tous', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'].map((day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (_) => setState(() => _selectedDay = day),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]), const SizedBox(height: 20), const Text('Aucun cours')]))
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () => showDialog(context: context, builder: (c) => AlertDialog(title: Text(item['cours']), content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Jour: ${item['jour']}'), const SizedBox(height: 8), Text('Heure: ${item['heure']}'), const SizedBox(height: 8), Text('Salle: ${item['salle']}'), const SizedBox(height: 8), Text('Prof: ${item['prof']}')]), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Fermer'))])),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: Center(child: Text(item['heure'].split('-')[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue), textAlign: TextAlign.center)),
                              ),
                              title: Text(item['cours'], style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${item['jour']} - Salle ${item['salle']}'),
                                  Text(item['prof'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
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
