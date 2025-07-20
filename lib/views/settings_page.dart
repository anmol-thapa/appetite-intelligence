import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/services/auth_service.dart';
import 'package:appetite_intelligence/services/database_service.dart';
import 'package:appetite_intelligence/services/firebase_user_service.dart';
import 'package:appetite_intelligence/widgets/reusables/drop_down_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/primary_button_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/secondary_button_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  Set<int> selectedDays = {};
  int? selectedAge;
  int? selectedWeight;
  int? selectedHeight;

  final List<int> heightInInches = List.generate(24, (i) => i + 60);

  String formatHeight(int inches) {
    final feet = inches ~/ 12;
    final remainingInches = inches % 12;
    return "$feet'$remainingInches\"";
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(firebaseUser).valueOrNull;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    selectedDays = {...(user?.cheatMeals ?? [])};
    selectedAge = user?.age;
    selectedWeight = user?.weight;
    selectedHeight = user?.height;
  }

  Future<void> logout() async {
    await AuthService().logout();
  }

  void saveSettings() async {
    final updatedName = nameController.text.trim();
    final updatedDays = selectedDays.toList();
    final updatedAge = selectedAge;
    final updatedWeight = selectedWeight;
    final updatedHeight = selectedHeight;

    Map<String, dynamic> update = {
      'name': updatedName,
      'height': updatedHeight,
      'age': updatedAge,
      'weight': updatedWeight,
      'cheatMeals': updatedDays,
    };

    await DatabaseService.db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(update);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUser).valueOrNull;

    if ((nameController.text.isEmpty || nameController.text == 'Loading') &&
        user?.name != null) {
      nameController.text = user!.name;
    }

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: [
        TextFieldWidget(
          name: 'Name',
          controller: nameController,
          maxLength: 15,
        ),

        TextFieldWidget(
          name: 'Email',
          controller: emailController,
          maxLength: 255,
          enabled: false,
        ),

        const SizedBox(height: 20),

        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Cheat Days', style: KPageSettings.semiBold),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(dayLabels.length, (index) {
                final isoDay = index + 1;
                final isSelected = selectedDays.contains(isoDay);
                return ChoiceChip(
                  label: Text(dayLabels[index]),
                  selected: isSelected,
                  selectedColor: KColors.primaryColor,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        selectedDays.remove(isoDay);
                      } else if (selectedDays.length < 2) {
                        selectedDays.add(isoDay);
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            const Text(
              '*You may pick up to 2 cheat days',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),

            DropDownWidget<int>(
              label: 'Age',
              value: selectedAge,
              hint: "Select age...",
              onChanged: (val) => setState(() => selectedAge = val),
              items:
                  List.generate(82, (i) => i + 18)
                      .map(
                        (age) => DropdownMenuItem(
                          value: age,
                          child: Text(age.toString()),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 10),

            DropDownWidget<int>(
              label: 'Weight',
              value: selectedWeight,
              hint: "Select weight...",
              onChanged: (val) => setState(() => selectedWeight = val),
              items:
                  List.generate(201, (i) => i + 100)
                      .map(
                        (w) =>
                            DropdownMenuItem(value: w, child: Text("$w lbs")),
                      )
                      .toList(),
            ),

            const SizedBox(height: 10),

            DropDownWidget<int>(
              label: 'Height',
              value: selectedHeight,
              hint: "Select height...",
              onChanged: (val) => setState(() => selectedHeight = val),
              items:
                  heightInInches.map((inches) {
                    final feet = inches ~/ 12;
                    final inch = inches % 12;
                    return DropdownMenuItem<int>(
                      value: inches,
                      child: Text("$feet'$inch\""),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(onClick: saveSettings, text: 'Save Settings'),
              SecondaryButton(onClick: logout, text: 'Logout'),
            ],
          ),
        ),
      ],
    );
  }
}
