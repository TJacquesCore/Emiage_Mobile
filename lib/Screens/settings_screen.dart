import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../theme/app_design.dart';

class SettingsScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function()? onLogout;

  const SettingsScreen({
    super.key,
    required this.title,
    required this.icon,
    this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  String _selectedLanguage = 'Français';
  bool _twoFactorEnabled = true;
  int _connectedDevices = 2;

  // Controllers pour les champs éditables
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _studentNumberController;
  late TextEditingController _phoneController;
  late TextEditingController _permanentIdController;
  late TextEditingController _emailController;
  
  // Variable pour gérer le mode édition
  bool _isEditingProfile = false;
  
  // Valeur sélectionnée pour le niveau
  String? _selectedLevel;
  final List<String> _levels = ['L1', 'L2', 'L3', 'M1', 'M2'];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: userFirstNameNotifier.value ?? '');
    _lastNameController = TextEditingController(text: userLastNameNotifier.value ?? '');
    _studentNumberController = TextEditingController(text: userStudentNumberNotifier.value ?? '');
    _phoneController = TextEditingController(text: userPhoneNotifier.value ?? '');
    _permanentIdController = TextEditingController(text: userPermanentIdNotifier.value ?? '');
    _emailController = TextEditingController(text: currentUserEmailNotifier.value ?? '');
    _selectedLevel = userLevelNotifier.value;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentNumberController.dispose();
    _phoneController.dispose();
    _permanentIdController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  BoxDecoration _getCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(AppDesign.radiusL),
      border: Border.all(
        color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        width: 1,
      ),
    );
  }

  Color _getDividerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[700]! : Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Profile
          ValueListenableBuilder<String?>(
            valueListenable: currentUserNotifier,
            builder: (context, currentUser, _) {
              return ValueListenableBuilder<String?>(
                valueListenable: currentUserEmailNotifier,
                builder: (context, currentEmail, _) {
                  return Container(
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
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentUser ?? 'Non connecté',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentEmail ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 30),

          // Profile Information Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations du Profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: _getCardDecoration(context),
                  child: Column(
                    children: [
                      if (_isEditingProfile)
                        // Mode édition
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildEditableField(
                                context,
                                Icons.person_outline,
                                'Nom',
                                _lastNameController,
                                Colors.deepPurple,
                              ),
                              const SizedBox(height: 12),
                              _buildEditableField(
                                context,
                                Icons.person_outline,
                                'Prénom',
                                _firstNameController,
                                Colors.deepPurple,
                              ),
                              const SizedBox(height: 12),
                              _buildEditableField(
                                context,
                                Icons.email_outlined,
                                'Email',
                                _emailController,
                                Colors.cyan,
                              ),
                              const SizedBox(height: 12),
                              _buildLevelDropdown(context),
                              const SizedBox(height: 12),
                              _buildEditableField(
                                context,
                                Icons.badge_outlined,
                                'Numéro Étudiant',
                                _studentNumberController,
                                Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              _buildEditableField(
                                context,
                                Icons.fingerprint,
                                'Identifiant Permanent',
                                _permanentIdController,
                                Colors.red,
                              ),
                              const SizedBox(height: 12),
                              _buildEditableField(
                                context,
                                Icons.phone_outlined,
                                'Téléphone',
                                _phoneController,
                                Colors.teal,
                              ),
                            ],
                          ),
                        )
                      else
                        // Mode affichage
                        Column(
                          children: [
                            ValueListenableBuilder<String?>(
                              valueListenable: userLastNameNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.person_outline,
                                'Nom',
                                v ?? '—',
                                Colors.deepPurple,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: userFirstNameNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.person_outline,
                                'Prénom',
                                v ?? '—',
                                Colors.deepPurple,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: currentUserEmailNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.email_outlined,
                                'Email',
                                v ?? '—',
                                Colors.cyan,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: userClassNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.school_outlined,
                                'Classe',
                                v ?? '—',
                                Colors.blue,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: userStudentNumberNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.badge_outlined,
                                'Numéro Étudiant',
                                v ?? '—',
                                Colors.orange,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: userPermanentIdNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.fingerprint,
                                'Identifiant Permanent',
                                v ?? '—',
                                Colors.red,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            ValueListenableBuilder<String?>(
                              valueListenable: userPhoneNotifier,
                              builder: (context, v, _) => _buildProfileTile(
                                context,
                                Icons.phone_outlined,
                                'Téléphone',
                                v ?? '—',
                                Colors.teal,
                              ),
                            ),
                            Divider(height: 0, color: _getDividerColor(context)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.link_outlined, color: Colors.purple, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Inscription',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () => launchUrl(Uri.parse('https://inscription.mesrs-ci.net/')),
                                          child: const Text(
                                            'Inscription en ligne',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
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
                const SizedBox(height: 16),
                // Boutons de gestion du profil
                _isEditingProfile
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                userLastNameNotifier.value = _lastNameController.text.isEmpty ? null : _lastNameController.text;
                                userFirstNameNotifier.value = _firstNameController.text.isEmpty ? null : _firstNameController.text;
                                currentUserEmailNotifier.value = _emailController.text.isEmpty ? null : _emailController.text;
                                userLevelNotifier.value = _selectedLevel;
                                userStudentNumberNotifier.value = _studentNumberController.text.isEmpty ? null : _studentNumberController.text;
                                userPermanentIdNotifier.value = _permanentIdController.text.isEmpty ? null : _permanentIdController.text;
                                userPhoneNotifier.value = _phoneController.text.isEmpty ? null : _phoneController.text;
                                setState(() {
                                  _isEditingProfile = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Informations du profil mises à jour'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Confirmer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _firstNameController.text = userFirstNameNotifier.value ?? '';
                                _lastNameController.text = userLastNameNotifier.value ?? '';
                                _studentNumberController.text = userStudentNumberNotifier.value ?? '';
                                _phoneController.text = userPhoneNotifier.value ?? '';
                                _permanentIdController.text = userPermanentIdNotifier.value ?? '';
                                _emailController.text = currentUserEmailNotifier.value ?? '';
                                _selectedLevel = userLevelNotifier.value;
                                setState(() {
                                  _isEditingProfile = false;
                                });
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('Annuler'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isEditingProfile = true;
                            });
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Modifier les infos du profil'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paramètres',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: _getCardDecoration(context),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        Icons.notifications_outlined,
                        'Notifications',
                        'Gérez vos préférences',
                        Colors.deepPurple,
                        () => _showNotificationsModal(),
                      ),
                      Divider(height: 0, color: _getDividerColor(context)),
                      _buildSettingsTile(
                        context,
                        Icons.language,
                        'Langue',
                        _selectedLanguage,
                        Colors.blue,
                        () => _showLanguageModal(),
                      ),
                      Divider(height: 0, color: _getDividerColor(context)),
                      _buildModeSombreTile(context),
                      Divider(height: 0, color: _getDividerColor(context)),
                      _buildSettingsTile(
                        context,
                        Icons.lock_outlined,
                        'Sécurité',
                        '2FA ${_twoFactorEnabled ? "activé" : "désactivé"}',
                        Colors.red,
                        () => _showSecurityModal(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(),
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    IconData icon,
    String label,
    TextEditingController controller,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: color, size: 20),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Widget _buildLevelDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: _selectedLevel,
        isExpanded: true,
        underline: const SizedBox(),
        items: _levels.map((String level) {
          return DropdownMenuItem<String>(
            value: level,
            child: Text(level),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedLevel = newValue;
          });
        },
        hint: const Text('Sélectionner le niveau'),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSombreTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.dark_mode_outlined, color: Colors.purple, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Sombre',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Adaptez à votre préférence',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: darkModeNotifier,
            builder: (context, isDark, _) {
              return Switch(
                value: isDark,
                onChanged: (value) {
                  darkModeNotifier.value = value;
                },
                activeColor: Colors.purple,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showNotificationsModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Activer les notifications'),
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
              if (_notificationsEnabled) ...[
                SwitchListTile(
                  title: const Text('Notifications par email'),
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                ),
                SwitchListTile(
                  title: const Text('Notifications push'),
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLanguageModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionner la langue'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Français', 'English', 'Español', 'Deutsch'].map((lang) {
              return ListTile(
                title: Text(lang),
                leading: Radio(
                  value: lang,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() => _selectedLanguage = value!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Langue changée en $lang'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showSecurityModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sécurité'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Authentification à deux facteurs'),
                value: _twoFactorEnabled,
                onChanged: (value) => setState(() => _twoFactorEnabled = value),
              ),
              const SizedBox(height: 16),
              const Text('Appareils connectés:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$_connectedDevices appareils'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout?.call();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

