- lib/
    - main.dart (entry point of the app)
    - screens/ (directory for all the app's screens/pages)
        - home.dart
        - log.dart
        - progress.dart
        - exercise_library.dart
        - training_plan.dart
        - stop_watch.dart
        - help.dart
    - models/ (directory for any data models used in the app)
        - exercise.dart
        - workout.dart
        - bmi.dart
        - user.dart
    - widgets/ (directory for reusable widgets used throughout the app)
        - collapse_card.dart
        - exercise_card.dart
        - progress_chart.dart
        - training_plan_item.dart
    - utils/ (directory for any utility functions or classes used in the app)
        - bmi_calculator.dart
        - converter.dart
        - novice_linear_program.dart
        - reminder.dart
        - vis.dart
    - services/ (directory for calculation or data fetching service for the app)
        - auth_service.dart
        - exercise.dart
        - training.dart
        - plan.dart
        - inter.dart
- (platform)/ (directory for adaptor of different OS)
- assets/ (directory for any assets such as images and videos)
- pubspec.yaml (dependency and asset management file)

Following OOP styles:
* encapsulation
* inheritance
* polymorphism
* the SOLID principles
  * Single Responsibility Principle (SRP): A class should have only one reason to change, meaning that it should have only one responsibility or job.
  * Open-Closed Principle (OCP): A class should be open for extension but closed for modification, meaning that it should be able to have its behavior extended without modifying its source code.
  * Liskov Substitution Principle (LSP): Derived classes should be substitutable for their base classes, meaning that objects of a superclass should be able to be replaced with objects of a subclass without altering the correctness of the program.
  * Interface Segregation Principle (ISP): A class should not be forced to implement interfaces it does not use, meaning that a class should not be required to implement methods it does not need.
  * Dependency Inversion Principle (DIP): High-level modules should not depend on low-level modules, but both should depend on abstractions, meaning that a class should not depend on a concrete implementation, but instead depend on an abstraction of that implementation.
