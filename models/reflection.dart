
class ReflectionResponse {
  final List<String> photos;
  final String reflectionId;
  final String reflection;
  final String uuid;
  final DateTime submitTime;
  final String userId;

  ReflectionResponse({
    required this.photos,
    required this.reflectionId,
    required this.reflection,
    required this.uuid,
    required this.submitTime,
    required this.userId,
  });

  factory ReflectionResponse.fromJson(Map<String, dynamic> json) {
    return ReflectionResponse(
      photos: List<String>.from(json['Photos']),
      reflectionId: json['reflection_id'],
      reflection: json['reflection'],
      uuid: json['UUID'],
      submitTime: DateTime.parse(json['SubmitTime']),
      userId: json['UserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Photos': photos,
      'reflection_id': reflectionId,
      'reflection': reflection,
      'UUID': uuid,
      'SubmitTime': submitTime.toIso8601String(),
      'UserId': userId,
    };
  }
}

