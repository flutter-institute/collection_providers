set -e # abort CI if error happens
cd $1
flutter packages get
flutter format --set-exit-if-changed lib test
flutter analyze --no-current-package lib test/
flutter test --no-pub --coverage

# reset state
cd -
