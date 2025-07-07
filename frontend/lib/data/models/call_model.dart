class CallModel {
  final int? id;
  final int? callerId;
  final int? receiverId;
  final String? callerImage;
  final String? receiverImage;
  final String? startTime;
  final String? endTime;
  final String? callStatus;
  final String? callType;
  final String? duration;
  final String? timestamp;
  final int? callConversationId;

  CallModel({
    this.id,
    this.callerId,
    this.receiverId,
    this.callerImage,
    this.receiverImage,
    this.startTime,
    this.endTime,
    this.callStatus,
    this.duration,
    this.callType,
    this.timestamp,
    this.callConversationId,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: json['id'],
      callerId: json['caller_id'],
      receiverId: json['receiver_id'],
      callerImage: json['caller_image'],
      receiverImage: json['receiver_image'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      callStatus: json['call_status'],
      duration: json['duration'],
      callType: json['call_type'],
      timestamp: json['timestamp'],
      callConversationId: json['call_conversation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller_id': callerId,
      'receiver_id': receiverId,
      'caller_image': callerImage,
      'receiver_image': receiverImage,
      'start_time': startTime,
      'end_time': endTime,
      'call_status': callStatus,
      'call_type': callType,
      'duration': duration,
      'timestamp': timestamp,
      'call_conversation_id': callConversationId,
    };
  }

  @override
  String toString() {
    return 'CallModel(id: $id, callerId: $callerId, receiverId: $receiverId, callerImage $callerImage receiverImage $receiverImage calltype: $callType, callStatus: $callStatus, startTime: $startTime, endTime: $endTime, duration: $duration, timestamp: $timestamp, callConversationId: $callConversationId)';
  }
}
