import 'package:flutter/material.dart';

class TaskModel {
  int? taskId;
  int? userId;
  int? patientId;
  String patientEmail;
  String patientName;
  String taskTitle;
  String taskPriority;
  String taskCategory;
  DateTime taskDueDate;
  TimeOfDay taskDueTime;
  String? taskDescription;

  TaskModel({
    this.taskId,
    this.userId,
    this.patientId,
    required this.patientEmail,
    required this.patientName,
    required this.taskTitle,
    required this.taskPriority,
    required this.taskCategory,
    required this.taskDueDate,
    required this.taskDueTime,
    this.taskDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'user_id': userId,
      'patient_id': patientId,
      'patient_email': patientEmail,
      'patient_name': patientName,
      'task_title': taskTitle,
      'task_priority': taskPriority,
      'task_category': taskCategory,
      'task_due_date': taskDueDate.toIso8601String().split('T').first,
      'task_due_time':
          '${taskDueTime.hour.toString().padLeft(2, '0')}:${taskDueTime.minute.toString().padLeft(2, '0')}',
      'task_description': taskDescription,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['task_due_time'] as String).split(':');
    return TaskModel(
      taskId: json['task_id'],
      userId: json['user_id'],
      patientId: json['patient_id'],
      patientEmail: json['patient_email'],
      patientName: json['patient_name'],
      taskTitle: json['task_title'],
      taskPriority: json['task_priority'],
      taskCategory: json['task_category'],
      taskDueDate: DateTime.parse(json['task_due_date']),
      taskDueTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      taskDescription: json['task_description'],
    );
  }

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, userId: $userId, patient_id: $patientId, patientEmail: $patientEmail, patientName: $patientName, taskTitle: $taskTitle, '
        'taskPriority: $taskPriority, taskCategory: $taskCategory, '
        'taskDueDate: ${taskDueDate.toIso8601String().split('T').first}, '
        'taskDueTime: ${taskDueTime.hour.toString().padLeft(2, '0')}:${taskDueTime.minute.toString().padLeft(2, '0')}, '
        'taskDescription: $taskDescription)';
  }
}
