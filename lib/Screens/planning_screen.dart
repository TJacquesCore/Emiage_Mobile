import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import 'planning_detail_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as ex;

class PlanningScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const PlanningScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  List<Map<String, dynamic>> planningData = [];

  String selectedDay = 'Lundi';

  Future<void> _importFromExcel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );
      if (result == null) return;

      final bytes = result.files.single.bytes;
      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impossible de lire le fichier (pas de données en mémoire).')),
          );
        }
        return;
      }

      final excel = ex.Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucune feuille trouvée dans ce fichier.')),
        );
        return;
      }

      final table = excel.tables.values.first;
      // Attendu: en-têtes: jour, nom, heure, salle, professeur, couleur
      final headers = table.rows.first.map((e) => (e?.value ?? '').toString().toLowerCase()).toList();
      int idxJour = headers.indexOf('jour');
      int idxNom = headers.indexOf('nom');
      int idxHeure = headers.indexOf('heure');
      int idxSalle = headers.indexOf('salle');
      int idxProf = headers.indexOf('professeur');
      int idxCouleur = headers.indexOf('couleur');
      if ([idxJour, idxNom, idxHeure, idxSalle].any((i) => i < 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entêtes requis manquants: jour, nom, heure, salle.')),
        );
        return;
      }

      final Map<String, List<Map<String, String>>> grouped = {};
      for (var i = 1; i < table.rows.length; i++) {
        final r = table.rows[i];
        String jour = (r[idxJour]?.value ?? '').toString();
        if (jour.isEmpty) continue;
        grouped.putIfAbsent(jour, () => []);
        grouped[jour]!.add({
          'nom': (r[idxNom]?.value ?? '').toString(),
          'heure': (r[idxHeure]?.value ?? '').toString(),
          'salle': (r[idxSalle]?.value ?? '').toString(),
          'professeur': idxProf >= 0 ? (r[idxProf]?.value ?? '').toString() : '',
          'couleur': idxCouleur >= 0 ? (r[idxCouleur]?.value ?? '0xFF4A90E2').toString() : '0xFF4A90E2',
        });
      }

      final imported = grouped.entries.map((e) => {
            'jour': e.key,
            'date': '',
            'cours': e.value,
          }).toList();

      setState(() {
        planningData = imported;
        if (planningData.isNotEmpty) {
          selectedDay = planningData.first['jour'];
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emploi du temps importé avec succès.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'import: $e')),
        );
      }
    }
  }

  void _showAddEventDialog() {
    final _form = GlobalKey<FormState>();
    String jour = selectedDay;
    String nom = '';
    String heure = '';
    String salle = '';
    String professeur = '';
    String couleur = '0xFF4A90E2';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un événement'),
        content: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: jour,
                  decoration: const InputDecoration(labelText: 'Jour'),
                  items: ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => jour = v ?? jour,
                ),
                TextFormField(decoration: const InputDecoration(labelText: 'Nom'), onChanged: (v) => nom = v, validator: (v)=> (v==null||v.isEmpty)?'Requis':null),
                TextFormField(decoration: const InputDecoration(labelText: 'Heure (ex: 08:00 - 10:00)'), onChanged: (v)=> heure=v, validator:(v)=>(v==null||v.isEmpty)?'Requis':null),
                TextFormField(decoration: const InputDecoration(labelText: 'Salle'), onChanged: (v)=> salle=v, validator:(v)=>(v==null||v.isEmpty)?'Requis':null),
                TextFormField(decoration: const InputDecoration(labelText: 'Professeur'), onChanged: (v)=> professeur=v),
                TextFormField(decoration: const InputDecoration(labelText: 'Couleur (hex 0xFFxxxxxx)'), onChanged: (v)=> couleur=v),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: (){
              if(_form.currentState!.validate()){
                setState((){
                  final day = planningData.firstWhere(
                    (d)=> d['jour'] == jour,
                    orElse: (){ final map={'jour': jour,'date':'','cours':<Map<String,String>>[]}; planningData.add(map); return map; },
                  );
                  (day['cours'] as List).add({'nom':nom,'heure':heure,'salle':salle,'professeur':professeur,'couleur':couleur});
                  selectedDay = jour;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayData = planningData.isNotEmpty
        ? planningData.firstWhere((d) => d['jour'] == selectedDay, orElse: () => planningData.first)
        : null;

    return Column(
      children: [
        // Header avec gradient
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppDesign.mainGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppDesign.radiusXL),
              bottomRight: Radius.circular(AppDesign.radiusXL),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                'Planning',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Gérez votre emploi du temps',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Actions principales
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _importFromExcel,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Importer (Excel)'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showAddEventDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Créer un évènement'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Jours de la semaine (si données)
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: planningData.length,
            itemBuilder: (context, index) {
              final day = planningData[index]['jour'];
              final isSelected = day == selectedDay;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Contenu
        Expanded(
          child: planningData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.event_busy, size: 48, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Aucun planning pour le moment.'),
                      SizedBox(height: 6),
                      Text('Importez un fichier Excel ou créez votre planning.'),
                    ],
                  ),
                )
              : Builder(
                  builder: (context) {
                    final currentDay = dayData!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: (currentDay['cours'] as List).length,
                      itemBuilder: (context, index) {
                        final cours = currentDay['cours'][index];
                        final couleur = Color(int.parse(cours['couleur'] ?? '0xFF4A90E2'));

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlanningDetailScreen(event: cours),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                side: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[700]!
                                      : Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Barre de couleur à gauche
                                  Container(
                                    width: 5,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: couleur,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(AppDesign.radiusL),
                                        bottomLeft: Radius.circular(AppDesign.radiusL),
                                      ),
                                    ),
                                  ),
                                  // Contenu
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Titre et type
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  cours['nom'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: couleur.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Cours',
                                                  style: TextStyle(
                                                    color: couleur,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Détails (Heure, Salle, Professeur)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      cours['heure'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? Colors.grey[400]
                                                            : Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.room, size: 14, color: Colors.grey),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      cours['salle'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? Colors.grey[400]
                                                            : Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Icône de navigation
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
