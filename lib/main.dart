import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/tab_screen.dart';
import 'Screens/cours_screen.dart';
import 'Screens/informations_screen.dart';
import 'Screens/planning_screen.dart';
import 'Screens/contacts_screen.dart';
import 'Screens/plats_screen.dart';
import 'Screens/settings_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/post_information_screen.dart';
import 'providers/auth_provider.dart';

// ValueNotifier global pour le mode sombre
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

// Variable globale pour l'utilisateur connecté
final ValueNotifier<String?> currentUserNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> currentUserEmailNotifier = ValueNotifier<String?>(null);
// Profils étendus
final ValueNotifier<String?> userLastNameNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userFirstNameNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userStudentNumberNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userPhoneNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userPermanentIdNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userClassNotifier = ValueNotifier<String?>(null);
final ValueNotifier<String?> userLevelNotifier = ValueNotifier<String?>(null);

// Système de rôles et administrateurs
final ValueNotifier<String?> userRoleNotifier = ValueNotifier<String?>(null);
// Rôles : null (étudiant normal), "delegue" (délégué), "sous_delegue" (sous-délégué), "chef_td" (chef de groupe de TD)

// Liste des restaurants ajoutés par les étudiants
final List<Map<String, String>> restaurants = [];

// Liste des ressources (images et documents pour la section Informations)
final List<Map<String, String>> ressources = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'EMIAGE App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF), // secondary
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F5F7),
            textTheme: _buildTextTheme(Brightness.light),
            fontFamily: GoogleFonts.poppins().fontFamily,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1A1A2E),
            textTheme: _buildTextTheme(Brightness.dark),
            fontFamily: GoogleFonts.poppins().fontFamily,
            useMaterial3: true,
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(title: 'EMIAGE'),
        );
      },
    );
  }
}

TextTheme _buildTextTheme(Brightness brightness) {
  final base = brightness == Brightness.dark
      ? ThemeData(brightness: Brightness.dark).textTheme
      : ThemeData(brightness: Brightness.light).textTheme;
  final poppins = GoogleFonts.poppinsTextTheme(base);
  return poppins.copyWith(
    displayLarge: GoogleFonts.montserrat(textStyle: poppins.displayLarge),
    displayMedium: GoogleFonts.montserrat(textStyle: poppins.displayMedium),
    displaySmall: GoogleFonts.montserrat(textStyle: poppins.displaySmall),
    headlineLarge: GoogleFonts.montserrat(textStyle: poppins.headlineLarge),
    headlineMedium: GoogleFonts.montserrat(textStyle: poppins.headlineMedium),
    headlineSmall: GoogleFonts.montserrat(textStyle: poppins.headlineSmall),
    titleLarge: GoogleFonts.montserrat(textStyle: poppins.titleLarge),
    titleMedium: GoogleFonts.montserrat(textStyle: poppins.titleMedium),
    titleSmall: GoogleFonts.montserrat(textStyle: poppins.titleSmall),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _publications = [];
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
  }

  void _handleLogin(String email, String password) {
    _authProvider.login(email, password).then((success) {
      if (success) {
        currentUserNotifier.value = _authProvider.currentUser;
        currentUserEmailNotifier.value = _authProvider.userEmail;
        // Prefill fictitious data for test account
        if ((email).toLowerCase() == 'test@emiage.com') {
          userFirstNameNotifier.value = 'Compte';
          userLastNameNotifier.value = 'Test';
          userClassNotifier.value = 'M1 Informatique';
          userStudentNumberNotifier.value = 'EMG12345';
          userPhoneNotifier.value = '+33 6 12 34 56 78';
          userPermanentIdNotifier.value = 'PID-TEST-0001';
        }
        // Note: Les données du profil des autres comptes sont préservées 
        // (elles ont été sauvegardées lors de l'inscription)
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenue ${_authProvider.currentUser}!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    });
  }

  void _handleLogout() {
    _authProvider.logout();
    currentUserNotifier.value = null;
    currentUserEmailNotifier.value = null;
    // Note: Les données du profil (prénom, nom, etc.) sont conservées
    // car elles ne sont pas sensibles et appartiennent à l'utilisateur
    setState(() {});
  }

  void _ajouterPublication(Map<String, String> nouvellePublication) {
    setState(() {
      _publications.add(nouvellePublication);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const TabScreen(title: 'Accueil', icon: Icons.home);
      case 1:
        return const CoursScreen(title: 'Cours', icon: Icons.school);
      case 2:
        return InformationsScreen(
          title: 'Informations',
          icon: Icons.info,
          publications: _publications,
          onRefresh: () {
            setState(() {});
          },
        );
      case 3:
        return const PlanningScreen(title: 'Planning', icon: Icons.calendar_today);
      case 4:
        return const ContactsScreen(title: 'Contacts', icon: Icons.contacts);
      case 5:
        return const PlatsScreen(title: 'Plats', icon: Icons.restaurant);
      case 6:
        return SettingsScreen(
          title: 'Paramètres',
          icon: Icons.settings,
          onLogout: _handleLogout,
        );
      default:
        return const TabScreen(title: 'Accueil', icon: Icons.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si pas d'utilisateur connecté, afficher LoginScreen
    if (_authProvider.currentUser == null) {
      return LoginScreen(onLogin: _handleLogin);
    }

    return Scaffold(
      body: _getScreen(_selectedIndex),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PostInformationScreen(),
                  ),
                ).then((result) {
                  if (result != null && result is Map<String, String>) {
                    _ajouterPublication(result);
                  }
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Cours'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Infos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planning'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Plats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}
