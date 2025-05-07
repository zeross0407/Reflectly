import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/models/response_model.dart';
import 'package:myrefectly/repository/repository.dart';

class SyncRepository {
  final Repository<String, Entry> _entryRepo;
  final Repository<String, Activity> _activityRepo;
  final Repository<String, Feeling> _feelingRepo;

  SyncRepository({
    required Repository<String, Entry> entryRepo,
    required Repository<String, Activity> activityRepo,
    required Repository<String, Feeling> feelingRepo,
  })  : _entryRepo = entryRepo,
        _activityRepo = activityRepo,
        _feelingRepo = feelingRepo;

  Future<void> syncUserData(UserData userData) async {
    await _syncMoodCheckins(userData.moodCheckinList);
    await _syncPhotos(userData.photoList);
    await _syncChallenges(userData.userChallengeList);
    await _syncReflections(userData.userReflectionList);
    await _syncVoiceNotes(userData.voicenoteList);
    await _syncActivities(userData.activityList);
    await _syncFeelings(userData.feelingList);
  }

  Future<void> _syncMoodCheckins(List<MoodCheckinList> moodCheckins) async {
    for (var element in moodCheckins) {
      await _entryRepo.add(
          element.uuid,
          MoodCheckin(
              UUID: element.uuid,
              submitTime: element.submitTime.toLocal(),
              title: element.title,
              description: element.description,
              mood: element.mood.toDouble(),
              activities: element.activities,
              feelings: element.feelings));
    }
  }

  Future<void> _syncPhotos(List<PhotoList> photos) async {
    for (var element in photos) {
      await _entryRepo.add(
        element.uuid,
        Photo(
          UUID: element.uuid,
          submitTime: element.submitTime.toLocal(),
        ),
      );
    }
  }

  Future<void> _syncChallenges(List<UserChallengeList> challenges) async {
    for (var element in challenges) {
      await _entryRepo.add(
          element.uuid,
          User_Challenge(
              UUID: element.uuid,
              description: element.description,
              submitTime: element.submitTime.toLocal(),
              photos: element.photos,
              challenge_id: element.challengeId));
    }
  }

  Future<void> _syncReflections(List<UserReflectionList> reflections) async {
    for (var element in reflections) {
      await _entryRepo.add(
          element.uuid,
          User_reflection(
              UUID: element.uuid,
              submitTime: element.submitTime.toLocal(),
              photos: element.photos,
              reflection: element.reflection,
              reflection_id: element.reflectionId));
    }
  }

  Future<void> _syncVoiceNotes(List<VoicenoteList> voiceNotes) async {
    for (var element in voiceNotes) {
      await _entryRepo.add(
        element.uuid,
        VoiceNote(
          UUID: element.uuid,
          submitTime: element.submitTime.toLocal(),
          description: element.description,
          title: element.title,
        ),
      );
    }
  }

  Future<void> _syncActivities(List<ActivityListElement> activities) async {
    for (var element in activities) {
      await _activityRepo.add(
          element.uuid,
          Activity(
              UUID: element.uuid,
              icon: element.icon,
              title: element.title,
              archive: element.archive));
    }
  }

  Future<void> _syncFeelings(List<ActivityListElement> feelings) async {
    for (var element in feelings) {
      await _feelingRepo.add(
          element.uuid,
          Feeling(
              UUID: element.uuid,
              icon: element.icon,
              title: element.title,
              archive: element.archive));
    }
  }
}
