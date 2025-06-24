import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/custom_checkbox.dart';
import 'package:doctor_app/presentation/widgets/custom_slider.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';

class MoodInfoScreen extends StatefulWidget {
  final Patient patient;
  const MoodInfoScreen({super.key, required this.patient});

  @override
  State<MoodInfoScreen> createState() => _MoodInfoScreenState();
}

class _MoodInfoScreenState extends State<MoodInfoScreen> {
  TextEditingController _enjoymentController = TextEditingController();
  TextEditingController _lifeEndingThoughtsController = TextEditingController();
  TextEditingController _injuredController = TextEditingController();
  TextEditingController _admittedToHospitalController = TextEditingController();
  TextEditingController _selfHarmedController = TextEditingController();
  TextEditingController _acquiredInjuryController = TextEditingController();
  TextEditingController _blameYourselfController = TextEditingController();
  // State variables
  bool depressiveIllness = false;
  String feelLowFrequency = '';
  double moodLevel = 5;

  double selfEsteemLevel = 1;

  bool cryToggle = false;
  String cryFrequency = '';

  bool suicidalToggle = false;
  String suicidalFrequency = '';

  bool notWantToBeHereToggle = false;
  String notWantToBeHereFrequency = '';

  bool isWorthLiving = false;
  bool isEndingLife = false;
  bool isEndingThoughts = false;
  bool isInjured = false;

  bool _isAdmittedToHospital = false;
  bool _isSelfHarmed = false;
  bool _isAcquiredInjury = false;
  bool _isBlameYourself = false;

  String? overlyHappy;

  bool wantToDieToggle = false;
  String wantToDieFrequency = '';

  String? selectedAngerLevel;
  String? selectedagitatedLevel;
  List<String> angerLevelOptions = ['no', 'sometimes', 'often'];

  String? selectedFeelLow;
  String? selectedFeelElated;
  List<String> durationOptions = [
    'A few hours',
    'Days',
    'Weeks',
    'A few months',
  ];

  // More state variables for checkboxes
  Map<String, bool> moodRelatedQuestions = {
    "Do you feel your mood gets worse in the morning?": false,
    "Does your mood stay constantly low?": false,
    "Are you able to smile?": false,
    "Are you able to laugh?": false,
    "Can you have normal appetite and enjoy activities?": false,
  };

  Map<String, bool> endingYourLifeRelatedQuestions = {
    "Has there been any blood vessel damage?": false,
    "Has there been any nerve damage?": false,
    "Have you ever required stitches?": false,
    "Have you ever required surgery?": false,
    "Any permanent damage of self harming?": false,
    "Do you have good confidence and self-esteem?": false,
  };

  Map<String, bool> abnormalBehaviorsRelatedQuestions = {
    "Excessively Flirty": false,
    "Increase in Sex Drive": false,
    "Spending Money Recklessly": false,
    "Being Undressed in Public": false,
    "Buying Things Beyond Your Means": false,
    "Engaging in High-Risk Activities (e.g.,Driving Fast, Drugs)": false,
    "Increase in Self-Esteem and Confidence": false,
  };
  Map<String, bool> believesInSpecialPurposeRelatedQuestions = {
    "Do you think you're better than others?": false,
    "Do you believe you have special powers (e.g., talking to God)?": false,
    "Do you think you are extremely wealthy or knowledgeable?": false,
  };

  List<String> options = [
    "Every day",
    "Several times a day",
    "Every second day",
    "Once a week",
    "3 times a week",
    "Fortnightly",
    "Once a month",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mood Info"),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleSwitchWidget(
              label: 'Do you suffer from a depressive illness?',
              value: depressiveIllness,
              onChanged: (val) => setState(() => depressiveIllness = val),
            ),
            if (depressiveIllness)
              GenderRadioGroup(
                label: "If yes, how often do you feel low?",
                groupValue: feelLowFrequency,
                onChanged: (value) {
                  setState(() {
                    feelLowFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 12),
            CustomSlider(
              value: moodLevel,
              onChanged: (val) => setState(() => moodLevel = val),
              label: 'Pick a number to represent your mood',
            ),
            const SizedBox(height: 12),

            // Mood related questions
            const SizedBox(height: 8),
            ...moodRelatedQuestions.keys.map((question) {
              return CustomCheckbox(
                label: question,
                onChanged: (val) {
                  setState(() {
                    moodRelatedQuestions[question] = val as bool;
                  });
                },
                value: moodRelatedQuestions[question]!,
              );
            }),

            const SizedBox(height: 16),
            LabeledTextField(
              label:
                  'What things can you still enjoy please specify and explain?',
              hintText: 'Explain here...',
              controller: _enjoymentController,
            ),
            // Cry Section
            ToggleSwitchWidget(
              label: 'Do you cry?',
              value: cryToggle,
              onChanged: (val) => setState(() => cryToggle = val),
            ),
            if (cryToggle)
              GenderRadioGroup(
                label: "If yes, how often do you cry?",
                groupValue: cryFrequency,
                onChanged: (value) {
                  setState(() {
                    cryFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 16),
            CustomCheckbox(
              label: 'Do you feel your life is worth living?',
              value: isWorthLiving,
              onChanged: (val) {
                setState(() {
                  isWorthLiving = val as bool;
                });
              },
            ),
            // Suicidal thoughts
            ToggleSwitchWidget(
              label: 'Do you have suicidal thoughts?',
              value: suicidalToggle,
              onChanged: (val) => setState(() => suicidalToggle = val),
            ),
            if (suicidalToggle)
              GenderRadioGroup(
                label: "If yes, how often do you feel suicidal?",
                groupValue: suicidalFrequency,
                onChanged: (value) {
                  setState(() {
                    suicidalFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 16),
            // Don't want to be here
            ToggleSwitchWidget(
              label: "Do you feel you don't want to be here?",
              value: notWantToBeHereToggle,
              onChanged: (val) => setState(() => notWantToBeHereToggle = val),
            ),
            if (notWantToBeHereToggle)
              GenderRadioGroup(
                label:
                    "If yes, how often do you feel you don't want to be here?",
                groupValue: notWantToBeHereFrequency,
                onChanged: (value) {
                  setState(() {
                    notWantToBeHereFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 16),
            ToggleSwitchWidget(
              label: "Do you have feelings you want to die?",
              value: wantToDieToggle,
              onChanged: (val) => setState(() => wantToDieToggle = val),
            ),
            if (wantToDieToggle)
              GenderRadioGroup(
                label: "If yes, how often do you feel you want to die?",
                groupValue: wantToDieFrequency,
                onChanged: (value) {
                  setState(() {
                    wantToDieFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 16),
            CustomCheckbox(
              label: 'Have you thought of any methods of ending your life?',
              value: isEndingLife,
              onChanged: (val) {
                setState(() {
                  isEndingLife = val as bool;
                });
              },
            ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you tried any of these thoughts?',
              value: isEndingThoughts,
              onChanged: (val) {
                setState(() {
                  isEndingThoughts = val;
                });
              },
            ),
            if (isEndingThoughts)
              LabeledTextField(
                label: 'If yes, what methods and how often?',
                hintText: 'Type here...',
                controller: _lifeEndingThoughtsController,
              ),

            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Has there been any injuries?',
              value: isInjured,
              onChanged: (val) {
                setState(() {
                  isInjured = val;
                });
              },
            ),
            if (isInjured)
              LabeledTextField(
                label: 'If yes, please explain about that injuries',
                hintText: 'Type here...',
                controller: _injuredController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you ever had to be admitted to hospital?',
              value: _isAdmittedToHospital,
              onChanged: (val) {
                setState(() {
                  _isAdmittedToHospital = val;
                });
              },
            ),
            if (_isAdmittedToHospital)
              LabeledTextField(
                label:
                    'If yes, please explain duration treatment and complications and outcome',
                hintText: 'Type here...',
                controller: _admittedToHospitalController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you ever self harmed?',
              value: _isSelfHarmed,
              onChanged: (val) {
                setState(() {
                  _isSelfHarmed = val;
                });
              },
            ),
            if (_isSelfHarmed)
              LabeledTextField(
                label: 'If yes, what methods please specify and explain',
                hintText: 'Type here...',
                controller: _selfHarmedController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you acquired any injuries?',
              value: _isAcquiredInjury,
              onChanged: (val) {
                setState(() {
                  _isAcquiredInjury = val;
                });
              },
            ),
            if (_isAcquiredInjury)
              LabeledTextField(
                label: 'If yes, please explain',
                hintText: 'Type here...',
                controller: _acquiredInjuryController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label:
                  'Do you blame yourself for your actions? And do you feel guilty?',
              value: _isBlameYourself,
              onChanged: (val) {
                setState(() {
                  _isBlameYourself = val;
                });
              },
            ),
            if (_isBlameYourself)
              LabeledTextField(
                label: 'If yes, what do you feel guilty about?',
                hintText: 'Type here...',
                controller: _blameYourselfController,
              ),
            const SizedBox(height: 8),
            ...endingYourLifeRelatedQuestions.keys.map((question) {
              return CustomCheckbox(
                label: question,
                onChanged: (val) {
                  setState(() {
                    endingYourLifeRelatedQuestions[question] = val as bool;
                  });
                },
                value: endingYourLifeRelatedQuestions[question]!,
              );
            }),
            const SizedBox(height: 12),
            CustomSlider(
              value: selfEsteemLevel,
              onChanged: (val) => setState(() => selfEsteemLevel = val),
              label:
                  'How would you describe your self-esteem?\n0 (Worst) to 10 (Normal):',
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: "Do you feel excessively elated or overly happy?",
              groupValue: overlyHappy,
              onChanged: (value) {
                setState(() {
                  overlyHappy = value!;
                });
              },
              options: options,
            ),
            const SizedBox(height: 8),
            Text(
              'Have you ever engaged in behaviors you wouldn’t normally do?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...abnormalBehaviorsRelatedQuestions.keys.map((question) {
              return CustomCheckbox(
                label: question,
                onChanged: (val) {
                  setState(() {
                    abnormalBehaviorsRelatedQuestions[question] = val as bool;
                  });
                },
                value: abnormalBehaviorsRelatedQuestions[question]!,
              );
            }),

            const SizedBox(height: 8),
            Text(
              'Do you believe you have special abilities or purpose?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...believesInSpecialPurposeRelatedQuestions.keys.map((question) {
              return CustomCheckbox(
                label: question,
                onChanged: (val) {
                  setState(() {
                    believesInSpecialPurposeRelatedQuestions[question] =
                        val as bool;
                  });
                },
                value: believesInSpecialPurposeRelatedQuestions[question]!,
              );
            }),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'Do you get easily angry?',
              groupValue: selectedAngerLevel,
              options: angerLevelOptions,
              onChanged: (val) {
                setState(() {
                  selectedAngerLevel = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'Do you get easily agitated?',
              groupValue: selectedagitatedLevel,
              options: angerLevelOptions,
              onChanged: (val) {
                setState(() {
                  selectedagitatedLevel = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'If you feel low, how long does it last?',
              groupValue: selectedFeelLow,
              options: durationOptions,
              onChanged: (val) {
                setState(() {
                  selectedFeelLow = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'If you feel elated, how long does it last?',
              groupValue: selectedFeelElated,
              options: durationOptions,
              onChanged: (val) {
                setState(() {
                  selectedFeelElated = val;
                });
              },
            ),
            const SizedBox(height: 16),

            PrimaryCustomButton(
              text: "Save",
              onPressed: () {
                print("Saving form data...");
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
