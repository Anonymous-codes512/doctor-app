class InvoiceModel {
  int? id;
  int? patientId;
  String? patientName;
  String? invoiceNumber;
  double? amountDue;
  DateTime? dueDate;
  String? paymentStatus;

  InvoiceModel({
    this.id,
    this.patientId,
    this.patientName,
    this.invoiceNumber,
    this.amountDue,
    this.dueDate,
    this.paymentStatus,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      invoiceNumber: json['invoice_number'],
      amountDue: json['amount_due'],
      dueDate: DateTime.tryParse(json['due_date'].toString()),
      paymentStatus: json['payment_status'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'patient_name': patientName,
    'invoice_number': invoiceNumber,
    'amount_due': amountDue,
    'due_date': dueDate,
    'payment_status': paymentStatus,
  };

  @override
  String toString() {
    return 'Invoice With id : $id'
        'of patient: $patientName'
        'has invoice_number: $invoiceNumber'
        'has payable amount_due: $amountDue'
        'till due_date: $dueDate'
        'and payment_status: $paymentStatus';
  }
}
