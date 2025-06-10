import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/services/onboarding_service.dart';
import 'package:appetite_intelligence/services/ui_service.dart';
import 'package:appetite_intelligence/widgets/reusables/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage1 extends ConsumerStatefulWidget {
  const OnboardingPage1({super.key});

  @override
  ConsumerState<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends ConsumerState<OnboardingPage1> {
  int selectedItem = 0;
  late final FixedExtentScrollController selectionController;

  @override
  void initState() {
    super.initState();
    selectionController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("What's your age?", style: TextStyle(fontSize: 24)),
          SizedBox(
            height: 500,
            width: 200,
            child: ListWheelScrollView(
              itemExtent: 100,
              controller: selectionController,
              onSelectedItemChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
              children: List.generate(
                82,
                (index) => ScrollItem(
                  index: index,
                  selectedItem: selectedItem,
                  text: '${18 + index}',
                ),
              ),
            ),
          ),
          PrimaryButton(
            onClick: () {
              ref.read(onboardingProvider.notifier).setAge(18 + selectedItem);
              context.push('/onboarding/2');
            },
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}

class ScrollItem extends StatelessWidget {
  const ScrollItem({
    super.key,
    required this.index,
    required this.selectedItem,
    required this.text,
  });

  final int index;
  final int selectedItem;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color:
            index == selectedItem ? KColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: index == selectedItem ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class OnBoardingPage2 extends ConsumerStatefulWidget {
  const OnBoardingPage2({super.key});

  @override
  ConsumerState<OnBoardingPage2> createState() => _OnBoardingPage2State();
}

class _OnBoardingPage2State extends ConsumerState<OnBoardingPage2> {
  late final FixedExtentScrollController feetController;
  late final FixedExtentScrollController inchesController;
  int selectedFeet = 0;
  int selectedInches = 0;

  @override
  void initState() {
    super.initState();
    feetController = FixedExtentScrollController(initialItem: 0);
    inchesController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("What's your height?", style: TextStyle(fontSize: 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            SizedBox(
              height: 500,
              width: 100,
              child: ListWheelScrollView(
                itemExtent: 100,
                controller: feetController,
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedFeet = value;
                  });
                },
                children: List.generate(
                  2,
                  (index) => ScrollItem(
                    index: index,
                    selectedItem: selectedFeet,
                    text: '${5 + index}',
                  ),
                ),
              ),
            ),
            const Text('ft', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 20),
            SizedBox(
              height: 500,
              width: 100,
              child: ListWheelScrollView(
                itemExtent: 100,
                controller: inchesController,
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedInches = value;
                  });
                },
                children: List.generate(
                  12,
                  (index) => ScrollItem(
                    index: index,
                    selectedItem: selectedInches,
                    text: '$index',
                  ),
                ),
              ),
            ),
            const Text('in', style: TextStyle(fontSize: 18)),
          ],
        ),
        PrimaryButton(
          onClick: () {
            final heightInInches = ((5 + selectedFeet) * 12) + selectedInches;
            ref.read(onboardingProvider.notifier).setHeight(heightInInches);
            context.push('/onboarding/3');
          },
          text: 'Continue',
        ),
      ],
    );
  }
}

class OnBoardingPage3 extends ConsumerStatefulWidget {
  const OnBoardingPage3({super.key});

  @override
  ConsumerState<OnBoardingPage3> createState() => _OnBoardingPage3State();
}

class _OnBoardingPage3State extends ConsumerState<OnBoardingPage3> {
  final weightController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("What's your weight?", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                final weight = int.tryParse(value);
                if (weight != null) {
                  ref.read(onboardingProvider.notifier).setWeight(weight);
                }
              },
              cursorColor: KColors.primaryColor,
              decoration: InputDecoration(
                hintText: 'Enter weight (lb)',
                suffixText: 'lb',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: KColors.primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            onClick: () {
              final weight = int.tryParse(weightController.text);
              if (weight == null) {
                showSnackbar(context, "Please enter a valid weight.");
                return;
              }
              if (weight < 100 || weight > 300) {
                showSnackbar(
                  context,
                  "Weight must be at least 100 and at most 300.",
                );
              } else {
                ref.read(onboardingProvider.notifier).setWeight(weight);
                context.push('/onboarding/4');
              }
            },
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage4 extends ConsumerStatefulWidget {
  const OnBoardingPage4({super.key});

  @override
  ConsumerState<OnBoardingPage4> createState() => _OnBoardingPage4State();
}

class _OnBoardingPage4State extends ConsumerState<OnBoardingPage4> {
  String? selectedGender;
  String? selectedMacro;
  String? selectedGoal;
  String? selectedActivity;

  final genderOptions = ['Male', 'Female'];
  final macroOptions = [
    'Balanced',
    'High Protein',
    'High Fat',
    'Low Carb',
    'Keto',
  ];
  final goalOptions = ['Gain', 'Maintain', 'Lose'];
  final activityOptions = [
    'Office job',
    '1-2 days/week',
    '3-5 days/week',
    '6-7 days/week',
    '2x day',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        buildSection(
          'Select your gender',
          genderOptions,
          selectedGender,
          (value) => setState(() => selectedGender = value),
        ),
        buildSection(
          'Preferred macro balance',
          macroOptions,
          selectedMacro,
          (value) => setState(() => selectedMacro = value),
        ),
        buildSection(
          'Weight goal',
          goalOptions,
          selectedGoal,
          (value) => setState(() => selectedGoal = value),
        ),
        buildSection(
          'Active level',
          activityOptions,
          selectedActivity,
          (value) => setState(() => selectedActivity = value),
        ),
        Center(
          child: Column(
            children: [
              PrimaryButton(
                onClick: () {
                  if (selectedGender != null &&
                      selectedMacro != null &&
                      selectedGoal != null &&
                      selectedActivity != null) {
                    final notifier = ref.read(onboardingProvider.notifier);
                    notifier.setGender(
                      selectedGender == 'Male' ? Gender.male : Gender.female,
                    );
                    notifier.setMacroBalance(
                      MacroBalance.values[macroOptions.indexOf(selectedMacro!)],
                    );
                    notifier.setWeightGoal(
                      WeightGoal.values[goalOptions.indexOf(selectedGoal!)],
                    );
                    notifier.setActivityLevel(
                      ActivityLevel.values[activityOptions.indexOf(
                        selectedActivity!,
                      )],
                    );
                    context.push('/onboarding/5');
                  } else {
                    showSnackbar(context, 'Please complete all fields');
                  }
                },
                text: 'Continue',
              ),
              const Text(
                '*Input from this page will not be stored and only used to calculate the daily goals.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSection(
    String title,
    List<String> options,
    String? selected,
    void Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              options.map((option) {
                return ChoiceChip(
                  selectedColor: KColors.primaryColor,
                  label: Text(option),
                  selected: selected == option,
                  onSelected: (selected) => onSelected(option),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class OnBoardingPage5 extends ConsumerStatefulWidget {
  const OnBoardingPage5({super.key});

  @override
  ConsumerState<OnBoardingPage5> createState() => _OnBoardingPage5State();
}

class _OnBoardingPage5State extends ConsumerState<OnBoardingPage5> {
  // Uses ISO 8601 day format
  final List<String> dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final Set<int> selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Pick your cheat meal days",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
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
          const SizedBox(height: 32),
          PrimaryButton(
            onClick: () {
              ref
                  .read(onboardingProvider.notifier)
                  .setCheatMealDays(cheatDays: selectedDays.toList());
              context.push('/onboarding/6');
            },
            text: 'Continue',
          ),
          const SizedBox(height: 12),
          const Text(
            '*You can skip this. Leaving it blank means no cheat days are scheduled.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage6 extends ConsumerStatefulWidget {
  const OnBoardingPage6({super.key});

  @override
  ConsumerState<OnBoardingPage6> createState() => _OnBoardingPage6State();
}

class _OnBoardingPage6State extends ConsumerState<OnBoardingPage6> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Let\'s finish up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              finalTextField(
                nameController,
                hint: 'Name',
                onChanged: (value) {
                  ref.read(onboardingProvider.notifier).setName(value);
                },
              ),
              const SizedBox(height: 24),
              finalTextField(
                emailController,
                hint: 'Email',
                onChanged: (value) {
                  ref.read(onboardingProvider.notifier).setEmail(value);
                },
              ),
              const SizedBox(height: 24),
              finalTextField(
                passwordController,
                hint: 'Password',
                obscure: true,
                onChanged: (value) {
                  ref.read(onboardingProvider.notifier).setPassword(value);
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onClick: () async {
                  String? message;
                  try {
                    isLoadingNotifier.value = true;
                    message =
                        await ref
                            .read(onboardingProvider.notifier)
                            .finalizeSignup();
                  } catch (err) {
                    message = err.toString();
                  } finally {
                    isLoadingNotifier.value = false;
                    if (mounted && message != null) {
                      showSnackbar(context, message);
                    }
                  }
                },
                text: 'Continue',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget finalTextField(
    TextEditingController controller, {
    required String hint,
    required ValueChanged<String> onChanged,
    bool obscure = false,
  }) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        cursorColor: KColors.primaryColor,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: KColors.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
