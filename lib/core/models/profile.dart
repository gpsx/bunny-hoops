import '../constants/app_strings.dart';

enum Profile {
  lontra,
  coelho;

  static Profile fromStorage(Object? value) {
    switch (value) {
      case 'lontra':
      case 'dado':
        return Profile.lontra;
      case 'coelho':
        return Profile.coelho;
      default:
        return Profile.coelho;
    }
  }

  String get storageValue => name;

  String get displayName {
    return switch (this) {
      Profile.lontra => AppStrings.profileLontra,
      Profile.coelho => AppStrings.profileCoelho,
    };
  }

  String get senderName {
    return switch (this) {
      Profile.lontra => AppStrings.sarky,
      Profile.coelho => AppStrings.amandinha,
    };
  }

  String get icon {
    return switch (this) {
      Profile.lontra => '🦦',
      Profile.coelho => '🐰',
    };
  }

  String get senderTopic {
    return switch (this) {
      Profile.lontra => 'lontra_thoughts',
      Profile.coelho => 'coelho_thoughts',
    };
  }

  Profile get recipient {
    return switch (this) {
      Profile.lontra => Profile.coelho,
      Profile.coelho => Profile.lontra,
    };
  }

  List<String> get subscriptionTopics {
    if (this == Profile.coelho) {
      return const ['lontra_thoughts', 'dado_thoughts'];
    }

    return const ['coelho_thoughts'];
  }
}
