class ReportModel {
  final int? id;
  final int? patientId;
  final int? doctorUserId;
  final String patientName;
  final String patientEmail;
  final String reportName;
  final String reportType;
  final String reportDate;
  final String reportTime;
  final String fileUrl;
  final double paymentAmount;
  final String paymentStatus;
  final String paymentMethod;

  ReportModel({
    this.id,
    this.patientId,
    this.doctorUserId,
    required this.patientName,
    required this.patientEmail,
    required this.reportName,
    required this.reportType,
    required this.reportDate,
    required this.reportTime,
    required this.fileUrl,
    required this.paymentAmount,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorUserId: json['doctor_user_id'],
      patientName: json['patient_name'],
      patientEmail: json['patient_email'],
      reportName: json['report_name'],
      reportType: json['report_type'],
      reportDate: json['report_date'],
      reportTime: json['report_time'],
      fileUrl: json['file_url'],
      paymentAmount: double.parse(json['payment_amount'].toString()),
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_user_id': doctorUserId,
      'patient_name': patientName,
      'patient_email': patientEmail,
      'report_name': reportName,
      'report_type': reportType,
      'report_date': reportDate,
      'report_time': reportTime,
      'file_url': fileUrl,
      'payment_amount': paymentAmount,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
    };
  }

  @override
  String toString() {
    return 'ReportModel(id: $id\n, patientId: $patientId\n, patientName: $patientName\n, patientEmail: $patientEmail\n, reportName: $reportName\n, reportType: $reportType\n, reportDate: $reportDate\n, reportTime: $reportTime\n, fileUrl: $fileUrl\n, paymentAmount: $paymentAmount\n, paymentStatus: $paymentStatus\n, paymentMethod: $paymentMethod\n)';
  }
}
