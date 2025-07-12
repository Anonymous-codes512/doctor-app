import 'package:flutter/material.dart';

class AppointmentModel {
  int? id;
  int? doctorId;
  int? patientId;
  String patientEmail;
  String patientName;
  int duration; // in minutes
  String? appointmentReason;
  String? appointmentMode;
  double fee;
  String? paymentMode;
  String description;
  DateTime appointmentDate;
  TimeOfDay appointmentTime;

  AppointmentModel({
    this.id,
    this.doctorId,
    this.patientId,
    required this.patientEmail,
    required this.patientName,
    required this.duration,
    this.appointmentReason,
    this.appointmentMode,
    required this.fee,
    this.paymentMode,
    required this.description,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'patient_email': patientEmail,
      'patient_name': patientName,
      'duration': duration,
      'reason': appointmentReason,
      'mode': appointmentMode,
      'fee': fee,
      'payment_mode': paymentMode,
      'description': description,
      'appointment_date': appointmentDate.toIso8601String().split('T').first,
      'appointment_time':
          '${appointmentTime.hour.toString().padLeft(2, '0')}:${appointmentTime.minute.toString().padLeft(2, '0')}',
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['appointment_time'] as String).split(':');
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      patientEmail: json['patient_email'],
      patientName: json['patient_name'],
      duration: json['duration'],
      appointmentReason: json['reason'],
      appointmentMode: json['mode'],
      fee: (json['fee'] as num).toDouble(),
      paymentMode: json['payment_mode'],
      description: json['description'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(doctorId: $doctorId, patientId: $patientId,patientEmail: $patientEmail, patientName: $patientName, duration: $duration, reason: $appointmentReason, mode: $appointmentMode, fee: $fee, paymentMode: $paymentMode, description: $description, date: ${appointmentDate.toIso8601String()}, time: ${appointmentTime.hour.toString().padLeft(2, '0')}:${appointmentTime.minute.toString().padLeft(2, '0')})';
  }
}
