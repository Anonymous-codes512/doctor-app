class MessageModel {
  final int? id;
  final int? senderId;
  final int? receiverId;
  final String? senderImage;
  final String? receiverImage;
  final String? encryptedMessage;
  final String? messageType;
  final bool? isRead;
  final String? readAt;
  final String? timestamp;
  final int? conversationId;

  MessageModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.senderImage,
    this.receiverImage,
    this.encryptedMessage,
    this.messageType,
    this.isRead,
    this.readAt,
    this.timestamp,
    this.conversationId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderImage: json['senderImage'],
      receiverImage: json['receiverImage'],
      encryptedMessage: json['encrypted_message'],
      messageType: json['message_type'] ?? 'text',
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      timestamp: json['timestamp'],
      conversationId: json['conversation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_image': senderImage,
      'receiver_image': receiverImage,
      'encrypted_message': encryptedMessage,
      'message_type': messageType,
      'is_read': isRead,
      'read_at': readAt,
      'timestamp': timestamp,
      'conversation_id': conversationId,
    };
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, receiverId: $receiverId, senderImage $senderImage receiverImage $receiverImage messageType: $messageType, encryptedMessage: $encryptedMessage)';
  }
}
