import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/app_design.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _studentNumberController;
  late TextEditingController _phoneController;
  late TextEditingController _permanentIdController;
  
  String _selectedClass = 'Licence 1';
  final List<String> _classOptions = [
    'Licence 1',
    'Licence 2',
    'Licence 3',
    'Master 1',
    'Master 2',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _lastNameController = TextEditingController(text: userLastNameNotifier.value ?? '');
    _firstNameController = TextEditingController(text: userFirstNameNotifier.value ?? '');
    _emailController = TextEditingController(text: currentUserEmailNotifier.value ?? '');
    _studentNumberController = TextEditingController(text: userStudentNumberNotifier.value ?? '');
    _phoneController = TextEditingController(text: userPhoneNotifier.value ?? '');
    _permanentIdController = TextEditingController(text: userPermanentIdNotifier.value ?? '');
    _selectedClass = userClassNotifier.value ?? 'Licence 1';
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _studentNumberController.dispose();
    _phoneController.dispose();
    _permanentIdController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusM),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusM),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusM),
              borderSide: const BorderSide(
                color: Color(0xFF6C63FF),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _handleSave() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    // Mettre à jour les notifiers globaux
    userLastNameNotifier.value = _lastNameController.text;
    userFirstNameNotifier.value = _firstNameController.text;
    currentUserEmailNotifier.value = _emailController.text;
    userStudentNumberNotifier.value = _studentNumberController.text;
    userPhoneNotifier.value = _phoneController.text;
    userPermanentIdNotifier.value = _permanentIdController.text;
    userClassNotifier.value = _selectedClass;

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Éditer le profil',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _lastNameController,
                    label: 'Nom',
                    icon: Icons.badge_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _firstNameController,
                    label: 'Prénom',
                    icon: Icons.person_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Classe dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Classe',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(AppDesign.radiusM),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedClass,
                    isExpanded: true,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                    items: _classOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          _selectedClass = newValue;
                        }
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(Icons.expand_more, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _studentNumberController,
              label: 'Numéro étudiant',
              icon: Icons.confirmation_number_rounded,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              label: 'Téléphone',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _permanentIdController,
              label: 'Identifiant permanent',
              icon: Icons.fingerprint_rounded,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesign.radiusM),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesign.radiusM),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : const Text(
                            'Enregistrer',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
