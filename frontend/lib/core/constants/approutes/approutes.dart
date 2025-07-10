import 'package:doctor_app/data/models/appointment_model.dart';
import 'package:doctor_app/data/models/invoice_model.dart';
import 'package:doctor_app/data/models/notes_model.dart';
import 'package:doctor_app/data/models/patient_model.dart';
import 'package:doctor_app/presentation/screens/home/doctor_profile.dart';
import 'package:doctor_app/presentation/screens/messages/chat_list_screen.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_appointment_screen.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_group_screen.dart';
import 'package:doctor_app/presentation/screens/patient/add_new_patient_screen.dart';
import 'package:doctor_app/presentation/screens/patient/add_note_screen.dart';
import 'package:doctor_app/presentation/screens/patient/appointment_screen.dart';
import 'package:doctor_app/presentation/screens/patient/correspondence_screen.dart';
import 'package:doctor_app/presentation/screens/patient/dictation_screen.dart';
import 'package:doctor_app/presentation/screens/patient/group_profile_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/activities_of_daily_living_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/family_history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/mood_assessment_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/mood_info_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/past_drug_history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/past_medical_history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/past_psychiatric_history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/history/personal_history_screen.dart';
import 'package:doctor_app/presentation/screens/patient/new_correspondence_screen.dart';
import 'package:doctor_app/presentation/screens/patient/notes_screen.dart';
import 'package:doctor_app/presentation/screens/patient/patient_profile_screen.dart';
import 'package:doctor_app/presentation/screens/patient/patient_report_screen.dart';
import 'package:doctor_app/presentation/screens/patient/patient_selection_screen.dart';
import 'package:doctor_app/presentation/screens/patient/personal_details_screen.dart';
import 'package:doctor_app/presentation/screens/patient/personal_stats_screen.dart';
import 'package:doctor_app/presentation/screens/patient/update_note_screen.dart';
import 'package:doctor_app/presentation/screens/reports/all_patients_reports.dart';
import 'package:doctor_app/presentation/screens/appointment/appointment_screen.dart';
import 'package:doctor_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:doctor_app/presentation/screens/auth/login_screen.dart';
import 'package:doctor_app/presentation/screens/auth/opening_screen.dart';
import 'package:doctor_app/presentation/screens/auth/otp_verification_screen.dart';
import 'package:doctor_app/presentation/screens/auth/password_changed_screen.dart';
import 'package:doctor_app/presentation/screens/auth/register_screen.dart';
import 'package:doctor_app/presentation/screens/auth/reset_password_screen.dart';
import 'package:doctor_app/presentation/screens/calendar/add_appointment_screen.dart';
import 'package:doctor_app/presentation/screens/calendar/add_task_screen.dart';
import 'package:doctor_app/presentation/screens/calendar/calendar_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bmi%20tracker/bmi_record_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bmi%20tracker/bmi_tacker_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bp%20tracker/bp_record_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/bp%20tracker/bp_tacker_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/analysis_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/health_tracker_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/health_tracker_start_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/pulse%20tracker/pulse_record_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/pulse%20tracker/pulse_tacker_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/reminders_settings_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/steps%20and%20calories%20counter/steps_and_calories_counter_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/weight%20tracker/weight_record_screen.dart';
import 'package:doctor_app/presentation/screens/health%20tracker%20screen/weight%20tracker/weight_tacker_screen.dart';
import 'package:doctor_app/presentation/screens/home/home_screen.dart';
import 'package:doctor_app/presentation/screens/invoice/invoice_details_screen.dart';
import 'package:doctor_app/presentation/screens/invoice/my_invoices_screen.dart';
import 'package:doctor_app/presentation/screens/messages/message_home_screen.dart';
import 'package:doctor_app/presentation/screens/messages/chat_screen.dart';
import 'package:doctor_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:doctor_app/presentation/screens/patient/my_patients_screen.dart';
import 'package:doctor_app/presentation/screens/payment/my_payments_screen.dart';
import 'package:doctor_app/presentation/screens/splash screen/splash_screen.dart';
import 'package:doctor_app/presentation/screens/task/task_screen.dart';
import 'package:doctor_app/presentation/screens/video/all_video_screen.dart';
import 'package:doctor_app/presentation/screens/voice/all_voice_screen.dart';
import 'package:doctor_app/presentation/screens/voice/call_list_screen.dart';
import 'package:doctor_app/presentation/screens/voice/calling_screen.dart';
import 'package:doctor_app/presentation/screens/voice/incoming_call_screen.dart';
import 'package:doctor_app/presentation/screens/voice/voice_detail_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';

  static const String updateDoctorProfile = '/update_doctor_profile';

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String openingScreen = '/opening_screen';
  static const String registerScreen = '/register_screen';
  static const String loginScreen = '/login_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String otpVerificationScreen = '/otp_verification_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String passwordChangedScreen = '/password_changed_screen';
  static const String homeScreen = '/home_screen';
  static const String allmessageScreen = '/all_message_screen';
  static const String chatScreen = '/chat_screen';
  static const String chatListScreen = '/chat_list_screen';

  static const String allVoiceCallsScreen = '/all_voice_screen';
  static const String callListScreen = '/call_list_screen';
  static const String voiceCallDetailScreen = '/voice_details_screen';
  static const String callingScreen = '/calling_screen';
  static const String inCommingCallScreen = '/in_comming_call_screen';

  static const String allVideoCallsScreen = '/all_video_screen';
  static const String healthTrackerStartScreen = '/health_tracker_start_screen';
  static const String healthTrackerScreen = '/health_tracker_screen';
  static const String analysisScreen = '/analysis_screen';
  static const String remindersSettingsScreen = '/reminders_settings_screen';
  static const String bpTrackerScreen = '/bp_tracker_screen';
  static const String bpRecordScreen = '/bp_record_screen';
  static const String weightTrackerScreen = '/weight_tracker_screen';
  static const String weightRecordScreen = '/weight_record_screen';
  static const String bmiTrackerScreen = '/bmi_tracker_screen';
  static const String bmiRecordScreen = '/bmi_record_screen';
  static const String pulseTrackerScreen = '/pulse_tracker_screen';
  static const String pulseRecordScreen = '/pulse_record_screen';
  static const String stepsAndCaloriesCounterScreen =
      '/steps_and_calories-ccounter_screen';
  static const String calendarScreen = '/calendar_screen';
  static const String addNewTaskScreen = '/add_new_task_screen';
  static const String addNewAppointmentScreen = '/add_new_appointment_screen';

  static const String myAppointmentScreen = '/my_appointment_screen';
  static const String myTaskScreen = '/my_task_screen';

  static const String myInvoicesScreen = '/my_invoices_screen';
  static const String invoiceDetailScreen = '/invoice_detail_screen';
  static const String paymentsScreen = '/payments_screen';
  static const String allPatientsReportsScreen = '/all_patients_reports_screen';

  static const String myPatientsScreen = '/my_patients_screen';
  static const String patientProfileScreen = '/patient_profile_screen';

  static const String addNewPatientScreen = '/add_new_patient_screen';
  static const String patientSelectionScreen = '/patient_selection_screen';
  static const String addNewGroupScreen = '/add_new_group_screen';
  static const String groupProfileScreen = '/group_profile_screen';
  static const String personalDetailsScreen = '/personal_details_screen';
  static const String personalStatsScreen = '/personal_stats_screen';
  static const String notesScreen = '/notes_screen';
  static const String addNoteScreen = '/add_note_screen';
  static const String updateNoteScreen = '/update_note_screen';

  static const String dictationScreen = '/dictation_screen';
  static const String correspondenceScreen = '/correspondence_screen';
  static const String newCorrespondenceScreen = '/new_correspondence_screen';
  static const String appointmentsScreen = '/appointments_screen';
  static const String addNewAppointmentsScreen = '/add_new_appointments_screen';

  static const String patientReportScreen = '/patient_report_screen';
  static const String historyScreen = '/history_screen';
  static const String pastMedicalHistoryScreen = '/past_medical_history_screen';
  static const String pastDrugHistoryScreen = '/past_drug_history_screen';
  static const String pastPsychiatricHistoryScreen =
      '/past_psychiatric_history_screen';
  static const String personalHistoryScreen = '/personal_history_screen';
  static const String moodAssessmentScreen = '/mood_assessment_screen';
  static const String moodInfoScreen = '/mood_info_screen';
  static const String activitiesOfDailyLivingScreen =
      '/activities_of_daily_living_screen';
  static const String familyHistoryScreen = '/family_history_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case openingScreen:
        return MaterialPageRoute(builder: (_) => const OpenningScreen());
      case registerScreen:
        final role = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RegisterScreen(role: role));
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case otpVerificationScreen:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(email: email),
        );
      case resetPasswordScreen:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: email),
        );
      case passwordChangedScreen:
        return MaterialPageRoute(builder: (_) => PasswordChangedScreen());
      case updateDoctorProfile:
        return MaterialPageRoute(builder: (_) => DoctorProfile());

      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case allmessageScreen:
        return MaterialPageRoute(builder: (_) => MessageHomeScreen());
      case chatScreen:
        final args = settings.arguments;
        if (args != null && args is Map<String, dynamic>) {
          return MaterialPageRoute(builder: (_) => ChatScreen(user: args));
        }
      case chatListScreen:
        final args = settings.arguments;
        if (args != null && args is List<Map<String, dynamic>>) {
          return MaterialPageRoute(builder: (_) => ChatListScreen(users: args));
        }

      case allVoiceCallsScreen:
        return MaterialPageRoute(builder: (_) => AllVoiceCallScreen());

      case callingScreen:
        final args = settings.arguments;
        if (args != null && args is Map<String, dynamic>) {
          return MaterialPageRoute(builder: (_) => CallingScreen(user: args));
        }

      case callListScreen:
        final args = settings.arguments;
        if (args != null && args is List<Map<String, dynamic>>) {
          return MaterialPageRoute(builder: (_) => CallListScreen(users: args));
        }

      case inCommingCallScreen:
        final args = settings.arguments;
        if (args != null && args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => IncomingCallScreen(callData: args),
          );
        }

      case voiceCallDetailScreen:
        final args = settings.arguments;
        if (args != null && args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => VoiceCallDetailScreen(user: args),
          );
        }

      case allVideoCallsScreen:
        return MaterialPageRoute(builder: (_) => AllVideoCallScreen());
      case healthTrackerStartScreen:
        return MaterialPageRoute(builder: (_) => HealthTrackerStartScreen());
      case healthTrackerScreen:
        return MaterialPageRoute(builder: (_) => HealthTrackerScreen());
      case analysisScreen:
        return MaterialPageRoute(builder: (_) => AnalysisScreen());
      case remindersSettingsScreen:
        return MaterialPageRoute(builder: (_) => RemindersSettingsScreen());
      case bpRecordScreen:
        return MaterialPageRoute(builder: (_) => BpRecordScreen());
      case bpTrackerScreen:
        final args = settings.arguments;
        List<Map<String, String>> records = [];
        if (args != null && args is List<Map<String, String>>) {
          records = args;
        }
        return MaterialPageRoute(
          builder: (_) => BpTrackerScreen(records: records),
        );

      case weightRecordScreen:
        return MaterialPageRoute(builder: (_) => WeightRecordScreen());
      case weightTrackerScreen:
        final args = settings.arguments;
        List<Map<String, String>> records = [];
        if (args != null && args is List<Map<String, String>>) {
          records = args;
        }
        return MaterialPageRoute(
          builder: (_) => WeightTrackerScreen(records: records),
        );

      case bmiRecordScreen:
        return MaterialPageRoute(builder: (_) => BMIRecordScreen());
      case bmiTrackerScreen:
        final args = settings.arguments;
        List<Map<String, String>> records = [];
        if (args != null && args is List<Map<String, String>>) {
          records = args;
        }
        return MaterialPageRoute(
          builder: (_) => BMITrackerScreen(records: records),
        );

      case pulseRecordScreen:
        return MaterialPageRoute(builder: (_) => PulseRecordScreen());
      case pulseTrackerScreen:
        final args = settings.arguments;
        List<Map<String, String>> records = [];
        if (args != null && args is List<Map<String, String>>) {
          records = args;
        }
        return MaterialPageRoute(
          builder: (_) => PulseTrackerScreen(records: records),
        );
      case stepsAndCaloriesCounterScreen:
        return MaterialPageRoute(builder: (_) => StepsCaloriesCounterScreen());
      case calendarScreen:
        return MaterialPageRoute(builder: (_) => CalendarScreen());
      case addNewTaskScreen:
        return MaterialPageRoute(builder: (_) => AddTaskScreen());
      case addNewAppointmentScreen:
        return MaterialPageRoute(builder: (_) => AddAppointmentScreen());

      case myAppointmentScreen:
        return MaterialPageRoute(builder: (_) => AppointmentScreen());

      case myTaskScreen:
        return MaterialPageRoute(builder: (_) => TaskScreen());

      case myInvoicesScreen:
        return MaterialPageRoute(builder: (_) => MyInvoicesScreen());

      case invoiceDetailScreen:
        final args = settings.arguments;
        if (args != null && args is InvoiceModel) {
          return MaterialPageRoute(
            builder: (_) => InvoiceDetailsScreen(invoice: args),
          );
        }

      case paymentsScreen:
        return MaterialPageRoute(builder: (_) => MyPaymentsScreen());

      case allPatientsReportsScreen:
        return MaterialPageRoute(builder: (_) => AllPatientsReportsScreen());

      case myPatientsScreen:
        return MaterialPageRoute(builder: (_) => MyPatientsScreen());

      case Routes.patientProfileScreen:
        final args = settings.arguments;
        if (args != null && args is Patient) {
          return MaterialPageRoute(
            builder: (_) => PatientProfileScreen(patient: args),
          );
        }

      case addNewPatientScreen:
        return MaterialPageRoute(builder: (_) => AddNewPatientScreen());

      case patientSelectionScreen:
        return MaterialPageRoute(builder: (_) => PatientSelectionScreen());

      case addNewGroupScreen:
        final args = settings.arguments;
        List<Map<String, dynamic>> patients = [];
        if (args != null && args is List<Map<String, dynamic>>) {
          patients = args;
        }
        return MaterialPageRoute(
          builder: (_) => AddNewGroupScreen(selectedPatients: patients),
        );

      case groupProfileScreen:
        final args = settings.arguments;
        Map<String, dynamic> patient = {};
        if (args != null && args is Map<String, dynamic>) {
          patient = args;
        }
        return MaterialPageRoute(
          builder: (_) => GroupProfileScreen(patientsGroup: patient),
        );

      case personalDetailsScreen:
        final args = settings.arguments;
        if (args != null && args is Patient) {
          return MaterialPageRoute(
            builder: (_) => PersonalDetailsScreen(patientData: args),
          );
        }

      case personalStatsScreen:
        final args = settings.arguments;
        if (args != null && args is Patient) {
          return MaterialPageRoute(
            builder: (_) => PersonalStatsScreen(patientData: args),
          );
        }

      case notesScreen:
        final args = settings.arguments;
        if (args != null && args is Map) {
          final notes = args['notes'] as List<Note>;
          final patientId = args['patientId'] as int;
          return MaterialPageRoute(
            builder: (_) => NotesScreen(notes: notes, patientId: patientId),
          );
        }

      case updateNoteScreen:
        final args = settings.arguments;
        if (args != null && args is Note) {
          return MaterialPageRoute(
            builder: (_) => UpdateNoteScreen(note: args),
          );
        }

      case addNoteScreen:
        final int patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => AddNoteScreen(patientId: patientId),
        );

      case dictationScreen:
        return MaterialPageRoute(builder: (_) => DictationScreen());

      case correspondenceScreen:
        return MaterialPageRoute(builder: (_) => CorrespondenceScreen());

      case newCorrespondenceScreen:
        return MaterialPageRoute(builder: (_) => NewCorrespondenceScreen());

      case appointmentsScreen:
        final int patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => AppointmentsScreen(patientId: patientId),
        );

      case addNewAppointmentsScreen:
        final args = settings.arguments;
        if (args != null && args is AppointmentModel) {
          return MaterialPageRoute(
            builder: (_) => AddNewAppointmentsScreen(appointmentModel: args),
          );
        }

      case patientReportScreen:
        return MaterialPageRoute(builder: (_) => PatientReportScreen());

      case historyScreen:
        final args = settings.arguments;
        if (args != null && args is Patient) {
          return MaterialPageRoute(
            builder: (_) => HistoryScreen(patient: args),
          );
        }

      case pastMedicalHistoryScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PastMedicalHistoryScreen(patientId: patientId),
        );

      case pastDrugHistoryScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PastDrugHistoryScreen(patientId: patientId),
        );

      case pastPsychiatricHistoryScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PastPsychiatricHistoryScreen(patientId: patientId),
        );

      case personalHistoryScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PersonalHistoryScreen(patientId: patientId),
        );

      case moodAssessmentScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MoodAssessmentScreen(patientId: patientId),
        );

      case moodInfoScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MoodInfoScreen(patientId: patientId),
        );

      case activitiesOfDailyLivingScreen:
        final patientId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ActivitiesOfDailyLivingScreen(patientId: patientId),
        );

      case familyHistoryScreen:
        final patientId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => FamilyHistoryScreen(patientId: patientId),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }

    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
    );
  }
}
