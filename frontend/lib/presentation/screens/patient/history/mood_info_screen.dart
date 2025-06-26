import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/widgets/custom_checkbox.dart';
import 'package:doctor_app/presentation/widgets/custom_slider.dart';
import 'package:doctor_app/presentation/widgets/gender_radio_group.dart';
import 'package:doctor_app/presentation/widgets/labeled_text_field.dart';
import 'package:doctor_app/presentation/widgets/primary_custom_button.dart';
import 'package:doctor_app/presentation/widgets/toggle_switch_widget.dart';
import 'package:doctor_app/provider/patient_provider.dart' show PatientProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodInfoScreen extends StatefulWidget {
  final int patientId;
  const MoodInfoScreen({super.key, required this.patientId});

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

  bool hasDepressiveIllness = false;
  String depressiveFrequency = '';
  double? moodLevel;

  bool moodWorseInMorning = false;
  bool moodConstantlyLow = false;
  bool canSmile = false;
  bool canLaugh = false;
  bool hasNormalAppetiteAndEnjoyment = false;

  bool hasCrying = false;
  String cryFrequency = '';

  bool feelsLifeWorth = false;

  bool hasSuicidalThoughts = false;
  String suicidalFrequency = '';

  bool feelsNotWantToBeHere = false;
  String notWantToBeHereFrequency = '';

  bool wantToDie = false;
  String wantToDieFrequency = '';

  bool hasEndingLifeThoughts = false;
  bool hasTriedEndingLife = false;
  bool hasInjuries = false;

  bool bloodVesselDamage = false;
  bool nerveDamage = false;
  bool requiredStitches = false;
  bool requiredSurgery = false;
  bool permanentDamageFromSelfHarm = false;
  bool hasConfidenceAndSelfEsteem = false;

  double selfEsteemLevel = 0;

  bool hasHospitalAdmission = false;
  bool hasSelfHarmed = false;
  bool hasAcquiredInjury = false;
  bool hasGuilt = false;

  String? overlyHappyFrequency;

  bool excessivelyFlirty = false;
  bool increasedSexDrive = false;
  bool recklessSpending = false;
  bool undressedInPublic = false;
  bool buysBeyondMeans = false;
  bool highRiskActivities = false;
  bool inflatedSelfEsteem = false;

  bool feelsSuperior = false;
  bool believesInPowers = false;
  bool feelsWealthyOrGenius = false;

  String? angerLevel;
  String? agitationLevel;
  String? lowMoodDuration;
  String? elatedMoodDuration;

  List<String> angerLevelOptions = ['no', 'sometimes', 'often'];
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

  late Patient patient;

  @override
  void initState() {
    super.initState();

    final patients =
        Provider.of<PatientProvider>(context, listen: false).patients;

    patient = patients.firstWhere((patient) => patient.id == widget.patientId);

    hasDepressiveIllness = patient.hasDepressiveIllness ?? false;
    depressiveFrequency = patient.depressiveFrequency ?? '';
    moodLevel = patient.moodLevel ?? 0;

    _enjoymentController = TextEditingController(text: patient.enjoyment ?? '');

    hasCrying = patient.hasCrying ?? false;
    cryFrequency = patient.cryFrequency ?? '';

    feelsLifeWorth = patient.feelsLifeWorth ?? false;
    hasSuicidalThoughts = patient.hasSuicidalThoughts ?? false;
    suicidalFrequency = patient.suicidalFrequency ?? '';

    feelsNotWantToBeHere = patient.feelsNotWantToBeHere ?? false;
    notWantToBeHereFrequency = patient.notWantToBeHereFrequency ?? '';

    wantToDie = patient.wantToDie ?? false;
    wantToDieFrequency = patient.wantToDieFrequency ?? '';

    hasEndingLifeThoughts = patient.hasEndingLifeThoughts ?? false;
    hasTriedEndingLife = patient.hasTriedEndingLife ?? false;
    _lifeEndingThoughtsController = TextEditingController(
      text: patient.lifeEndingThoughts ?? '',
    );

    hasInjuries = patient.hasInjuries ?? false;
    _injuredController = TextEditingController(text: patient.injured ?? '');

    hasHospitalAdmission = patient.hasHospitalAdmission ?? false;
    _admittedToHospitalController = TextEditingController(
      text: patient.admittedToHospital ?? '',
    );

    hasSelfHarmed = patient.hasSelfHarmed ?? false;
    _selfHarmedController = TextEditingController(
      text: patient.selfHarmed ?? '',
    );

    hasAcquiredInjury = patient.hasAcquiredInjury ?? false;
    _acquiredInjuryController = TextEditingController(
      text: patient.acquiredInjury ?? '',
    );

    hasGuilt = patient.hasGuilt ?? false;
    _blameYourselfController = TextEditingController(
      text: patient.guiltYourself ?? '',
    );

    selfEsteemLevel = patient.selfEsteemLevel ?? 0;
    overlyHappyFrequency = patient.overlyHappyFrequency ?? '';

    angerLevel = patient.angerLevel;
    agitationLevel = patient.agitationLevel;
    lowMoodDuration = patient.lowMoodDuration;
    elatedMoodDuration = patient.elatedMoodDuration;

    moodRelatedQuestions = {
      "Do you feel your mood gets worse in the morning?":
          patient.moodWorseInMorning ?? false,
      "Does your mood stay constantly low?": patient.moodConstantlyLow ?? false,
      "Are you able to smile?": patient.canSmile ?? false,
      "Are you able to laugh?": patient.canLaugh ?? false,
      "Can you have normal appetite and enjoy activities?":
          patient.hasNormalAppetiteAndEnjoyment ?? false,
    };

    endingYourLifeRelatedQuestions = {
      "Has there been any blood vessel damage?":
          patient.bloodVesselDamage ?? false,
      "Has there been any nerve damage?": patient.nerveDamage ?? false,
      "Have you ever required stitches?": patient.requiredStitches ?? false,
      "Have you ever required surgery?": patient.requiredSurgery ?? false,
      "Any permanent damage of self harming?":
          patient.permanentDamageFromSelfHarm ?? false,
      "Do you have good confidence and self-esteem?":
          patient.hasConfidenceAndSelfEsteem ?? false,
    };

    abnormalBehaviorsRelatedQuestions = {
      "Excessively Flirty": patient.excessivelyFlirty ?? false,
      "Increase in Sex Drive": patient.increasedSexDrive ?? false,
      "Spending Money Recklessly": patient.recklessSpending ?? false,
      "Being Undressed in Public": patient.undressedInPublic ?? false,
      "Buying Things Beyond Your Means": patient.buysBeyondMeans ?? false,
      "Engaging in High-Risk Activities (e.g.,Driving Fast, Drugs)":
          patient.highRiskActivities ?? false,
      "Increase in Self-Esteem and Confidence":
          patient.inflatedSelfEsteem ?? false,
    };

    believesInSpecialPurposeRelatedQuestions = {
      "Do you think you're better than others?": patient.feelsSuperior ?? false,
      "Do you believe you have special powers (e.g., talking to God)?":
          patient.believesInPowers ?? false,
      "Do you think you are extremely wealthy or knowledgeable?":
          patient.feelsWealthyOrGenius ?? false,
    };
  }

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
              value: hasDepressiveIllness,
              onChanged: (val) => setState(() => hasDepressiveIllness = val),
            ),
            if (hasDepressiveIllness)
              GenderRadioGroup(
                label: "If yes, how often do you feel low?",
                groupValue: depressiveFrequency,
                onChanged: (value) {
                  setState(() {
                    depressiveFrequency = value!;
                  });
                },
                options: options,
              ),
            const SizedBox(height: 12),
            CustomSlider(
              value: moodLevel!,
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
              value: hasCrying,
              onChanged: (val) => setState(() => hasCrying = val),
            ),
            if (hasCrying)
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
              value: feelsLifeWorth,
              onChanged: (val) {
                setState(() {
                  feelsLifeWorth = val as bool;
                });
              },
            ),
            // Suicidal thoughts
            ToggleSwitchWidget(
              label: 'Do you have suicidal thoughts?',
              value: hasSuicidalThoughts,
              onChanged: (val) => setState(() => hasSuicidalThoughts = val),
            ),
            if (hasSuicidalThoughts)
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
              value: feelsNotWantToBeHere,
              onChanged: (val) => setState(() => feelsNotWantToBeHere = val),
            ),
            if (feelsNotWantToBeHere)
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
              value: wantToDie,
              onChanged: (val) => setState(() => wantToDie = val),
            ),
            if (wantToDie)
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
              value: hasEndingLifeThoughts,
              onChanged: (val) {
                setState(() {
                  hasEndingLifeThoughts = val as bool;
                });
              },
            ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you tried any of these thoughts?',
              value: hasTriedEndingLife,
              onChanged: (val) {
                setState(() {
                  hasTriedEndingLife = val;
                });
              },
            ),
            if (hasTriedEndingLife)
              LabeledTextField(
                label: 'If yes, what methods and how often?',
                hintText: 'Type here...',
                controller: _lifeEndingThoughtsController,
              ),

            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Has there been any injuries?',
              value: hasInjuries,
              onChanged: (val) {
                setState(() {
                  hasInjuries = val;
                });
              },
            ),
            if (hasInjuries)
              LabeledTextField(
                label: 'If yes, please explain about that injuries',
                hintText: 'Type here...',
                controller: _injuredController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you ever had to be admitted to hospital?',
              value: hasHospitalAdmission,
              onChanged: (val) {
                setState(() {
                  hasHospitalAdmission = val;
                });
              },
            ),
            if (hasHospitalAdmission)
              LabeledTextField(
                label:
                    'If yes, please explain duration treatment and complications and outcome',
                hintText: 'Type here...',
                controller: _admittedToHospitalController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you ever self harmed?',
              value: hasSelfHarmed,
              onChanged: (val) {
                setState(() {
                  hasSelfHarmed = val;
                });
              },
            ),
            if (hasSelfHarmed)
              LabeledTextField(
                label: 'If yes, what methods please specify and explain',
                hintText: 'Type here...',
                controller: _selfHarmedController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label: 'Have you acquired any injuries?',
              value: hasAcquiredInjury,
              onChanged: (val) {
                setState(() {
                  hasAcquiredInjury = val;
                });
              },
            ),
            if (hasAcquiredInjury)
              LabeledTextField(
                label: 'If yes, please explain',
                hintText: 'Type here...',
                controller: _acquiredInjuryController,
              ),
            const SizedBox(height: 8),
            ToggleSwitchWidget(
              label:
                  'Do you blame yourself for your actions? And do you feel guilty?',
              value: hasGuilt,
              onChanged: (val) {
                setState(() {
                  hasGuilt = val;
                });
              },
            ),
            if (hasGuilt)
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
              groupValue: overlyHappyFrequency,
              onChanged: (value) {
                setState(() {
                  overlyHappyFrequency = value!;
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
              groupValue: angerLevel,
              options: angerLevelOptions,
              onChanged: (val) {
                setState(() {
                  angerLevel = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'Do you get easily agitated?',
              groupValue: agitationLevel,
              options: angerLevelOptions,
              onChanged: (val) {
                setState(() {
                  agitationLevel = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'If you feel low, how long does it last?',
              groupValue: lowMoodDuration,
              options: durationOptions,
              onChanged: (val) {
                setState(() {
                  lowMoodDuration = val;
                });
              },
            ),
            const SizedBox(height: 12),
            GenderRadioGroup(
              label: 'If you feel elated, how long does it last?',
              groupValue: elatedMoodDuration,
              options: durationOptions,
              onChanged: (val) {
                setState(() {
                  elatedMoodDuration = val;
                });
              },
            ),
            const SizedBox(height: 16),

            PrimaryCustomButton(
              text: "Save",
              onPressed: () {
                Provider.of<PatientProvider>(
                  context,
                  listen: false,
                ).updatePatientFields(
                  context,
                  patientId: widget.patientId,
                  updatedFields: {
                    'has_depressive_illness': hasDepressiveIllness,
                    'depressive_frequency': depressiveFrequency,
                    'mood_level': moodLevel,

                    'mood_worse_in_morning':
                        moodRelatedQuestions["Do you feel your mood gets worse in the morning?"] ??
                        false,
                    'mood_constantly_low':
                        moodRelatedQuestions["Does your mood stay constantly low?"] ??
                        false,
                    'can_smile':
                        moodRelatedQuestions["Are you able to smile?"] ?? false,
                    'can_laugh':
                        moodRelatedQuestions["Are you able to laugh?"] ?? false,
                    'has_normal_appetite_and_enjoyment':
                        moodRelatedQuestions["Can you have normal appetite and enjoy activities?"] ??
                        false,

                    'enjoyment_activities_description':
                        _enjoymentController.text.trim(),

                    'has_crying': hasCrying,
                    'cry_frequency': cryFrequency,
                    'feels_life_worth': feelsLifeWorth,

                    'has_suicidal_thoughts': hasSuicidalThoughts,
                    'suicidal_frequency': suicidalFrequency,
                    'feels_not_want_to_be_here': feelsNotWantToBeHere,
                    'not_want_to_be_here_frequency': notWantToBeHereFrequency,
                    'want_to_die': wantToDie,
                    'want_to_die_frequency': wantToDieFrequency,

                    'has_ending_life_thoughts': hasEndingLifeThoughts,
                    'has_tried_ending_life': hasTriedEndingLife,
                    'life_ending_methods_details':
                        hasTriedEndingLife
                            ? _lifeEndingThoughtsController.text.trim()
                            : null,

                    'has_injuries': hasInjuries,
                    'injuries_description':
                        hasInjuries ? _injuredController.text.trim() : null,

                    'has_hospital_admission': hasHospitalAdmission,
                    'hospital_admission_details':
                        hasHospitalAdmission
                            ? _admittedToHospitalController.text.trim()
                            : null,

                    'has_self_harmed': hasSelfHarmed,
                    'self_harmed_methods':
                        hasSelfHarmed
                            ? _selfHarmedController.text.trim()
                            : null,

                    'has_acquired_injury': hasAcquiredInjury,
                    'acquired_injury_description':
                        hasAcquiredInjury
                            ? _acquiredInjuryController.text.trim()
                            : null,

                    'has_guilt': hasGuilt,
                    'guilt_reason':
                        hasGuilt ? _blameYourselfController.text.trim() : null,

                    // Ending life related
                    'blood_vessel_damage':
                        endingYourLifeRelatedQuestions["Has there been any blood vessel damage?"] ??
                        false,
                    'nerve_damage':
                        endingYourLifeRelatedQuestions["Has there been any nerve damage?"] ??
                        false,
                    'required_stitches':
                        endingYourLifeRelatedQuestions["Have you ever required stitches?"] ??
                        false,
                    'required_surgery':
                        endingYourLifeRelatedQuestions["Have you ever required surgery?"] ??
                        false,
                    'permanent_damage_from_self_harm':
                        endingYourLifeRelatedQuestions["Any permanent damage of self harming?"] ??
                        false,
                    'has_confidence_and_self_esteem':
                        endingYourLifeRelatedQuestions["Do you have good confidence and self-esteem?"] ??
                        false,

                    'self_esteem_level': selfEsteemLevel,
                    'overly_happy_frequency': overlyHappyFrequency,

                    // Abnormal behaviors
                    'excessively_flirty':
                        abnormalBehaviorsRelatedQuestions["Excessively Flirty"] ??
                        false,
                    'increased_sex_drive':
                        abnormalBehaviorsRelatedQuestions["Increase in Sex Drive"] ??
                        false,
                    'reckless_spending':
                        abnormalBehaviorsRelatedQuestions["Spending Money Recklessly"] ??
                        false,
                    'undressed_in_public':
                        abnormalBehaviorsRelatedQuestions["Being Undressed in Public"] ??
                        false,
                    'buys_beyond_means':
                        abnormalBehaviorsRelatedQuestions["Buying Things Beyond Your Means"] ??
                        false,
                    'high_risk_activities':
                        abnormalBehaviorsRelatedQuestions["Engaging in High-Risk Activities (e.g.,Driving Fast, Drugs)"] ??
                        false,
                    'inflated_self_esteem':
                        abnormalBehaviorsRelatedQuestions["Increase in Self-Esteem and Confidence"] ??
                        false,

                    // Special beliefs
                    'feels_superior':
                        believesInSpecialPurposeRelatedQuestions["Do you think you're better than others?"] ??
                        false,
                    'believes_in_powers':
                        believesInSpecialPurposeRelatedQuestions["Do you believe you have special powers (e.g., talking to God)?"] ??
                        false,
                    'feels_wealthy_or_genius':
                        believesInSpecialPurposeRelatedQuestions["Do you think you are extremely wealthy or knowledgeable?"] ??
                        false,

                    // Mood duration and anger
                    'anger_level': angerLevel,
                    'agitation_level': agitationLevel,
                    'low_mood_duration': lowMoodDuration,
                    'elated_mood_duration': elatedMoodDuration,
                  },
                );
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
