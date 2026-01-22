import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_navigation_provider.g.dart';

/// Navigation indices for the bottom navigation bar.
enum HomeNavigationIndex {
  profile(0),
  home(1),
  log(2);

  const HomeNavigationIndex(this.value);
  final int value;
}

/// Notifier for managing the bottom navigation state.
@riverpod
class HomeNavigationStateNotifier extends _$HomeNavigationStateNotifier {
  @override
  int build() => HomeNavigationIndex.home.value;

  void setIndex(int index) {
    state = index;
  }

  void goToProfile() {
    state = HomeNavigationIndex.profile.value;
  }

  void goToHome() {
    state = HomeNavigationIndex.home.value;
  }
}
