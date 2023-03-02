import 'package:gymapp/models/exercise.dart';

// The ExerciseService class is used to get all exercises.
class ExerciseService {
  static final List<Exercise> exercises = [
    Exercise(
      name: 'Squat',
      description:
          'A compound exercise that works the quadriceps, hamstrings, glutes, and lower back.',
      image: 'assets/squat.jpg',
      steps: [
        'Begin by standing with your feet slightly wider than shoulder-width apart and your toes pointing forward.',
        'Place a barbell on your upper back, just below your neck. Your hands should grip the barbell with a slightly wider than shoulder-width grip.',
        'Take a deep breath and lower yourself by bending at the hips and knees, keeping your back straight and your chest up.',
        'Go as low as you can while still keeping your back straight and your heels on the ground.',
        'Push back up through your heels to the starting position.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=UXJrBgI2RxA',
    ),
    Exercise(
      name: 'Front Squat',
      description:
          'A compound exercise that works the quadriceps, hamstrings, glutes, and lower back.',
      image: 'assets/front_squat.jpg',
      steps: [
        'Begin by standing with your feet slightly wider than shoulder-width apart and your toes pointing forward.',
        'Place a barbell on your upper front, just below your neck. Your hands should grip the barbell with a slightly wider than shoulder-width grip.',
        'Take a deep breath and lower yourself by bending at the hips and knees, keeping your back straight and your chest up.',
        'Go as low as you can while still keeping your back straight and your heels on the ground.',
        'Push back up through your heels to the starting position.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=MVMNk0HiTMg',
    ),
    Exercise(
      name: 'Bench Press',
      description:
          'A compound exercise that works the chest, shoulders, and triceps.',
      image: 'assets/benchpress.jpg',
      steps: [
        'Lie on a flat bench with your feet flat on the floor and your back pressed firmly against the bench.',
        'Take a barbell with a slightly wider than shoulder-width grip.',
        'Take a deep breath and lower the barbell to your chest.',
        'Exhale and push the barbell back up to the starting position.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=ZOwwBk642SI',
    ),
    Exercise(
      name: 'Power Clean',
      description:
          'A full-body compound exercise that works the quadriceps, hamstrings, glutes, back, shoulders, and arms.',
      image: 'assets/squat.jpg',
      steps: [
        'Begin by standing with your feet hip-width apart and your toes pointing forward.',
        'Place a barbell on the floor in front of you.',
        'Grip the barbell with a slightly wider than shoulder-width grip.',
        'Take a deep breath and lift the barbell off the ground by explosively extending your hips and knees, keeping your back straight and your chest up.',
        'As the barbell reaches your thighs, pull yourself under it by quickly dropping your hips and bending your knees.',
        'Catch the barbell in a front squat position, with your elbows pointing forward.',
        'Stand up, bringing the barbell back to your shoulders.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=KwYJTpQ_x5A',
    ),
    Exercise(
      name: 'Deadlift',
      description:
          'A compound exercise that works the quadriceps, hamstrings, glutes, lower back, and traps.',
      image: 'assets/deadlift.jpg',
      steps: [
        'Begin by standing with your feet hip-width apart and your toes pointing forward.',
        'Place a barbell on the ground in front of you.',
        'Grip the barbell with a slightly wider than shoulder-width grip.',
        'Take a deep breath and lift the barbell off the ground by extending your hips and keeping your back straight.',
        'Stand up, bringing the barbell back to your hips.',
        'Lower the barbell back to the ground by bending your hips and keeping your back straight.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=o7Aj7Bq8Kos',
    ),
    Exercise(
      name: 'Press',
      description: 'An exercise that works the shoulders and triceps.',
      image: 'assets/press.jpg',
      steps: [
        'Sit down on a bench with a barbell at about chest level.',
        'Grip the barbell with a slightly wider than shoulder-width grip.',
        'Lift the barbell off the rack and position it above your chest.',
        'Lower the barbell down to your chest and press it back up to the starting position.',
        'Repeat for the desired number of reps.'
      ],
      video: 'https://www.youtube.com/watch?v=JImgCWzCHwI',
    ),
    Exercise(
      name: 'Chin-Ups',
      description: 'An exercise that works the biceps and back.',
      image: 'assets/chin-ups.jpg',
      steps: [
        'Grab a chin-up bar with an underhand grip (palms facing towards you).',
        'Hang from the bar with your arms fully extended.',
        'Pull yourself up towards the bar until your chin is above the bar.',
        'Lower yourself back down to the starting position.',
        'Repeat for the desired number of reps.'
      ],
      video: 'https://www.youtube.com/watch?v=b-ztMQpj8yc',
    ),
    Exercise(
      name: 'Pull-Ups',
      description:
          'An upper body exercise that works the latissimus dorsi, biceps, and forearms.',
      image: 'assets/chin-ups.jpg',
      steps: [
        'Begin by hanging from a pull-up bar with an overhand grip, your hands should be slightly wider than shoulder-width apart.',
        'Pull yourself up towards the bar by contracting your lats and biceps.',
        'Pause at the top of the movement, with your chin above the bar.',
        'Slowly lower yourself back to the starting position.',
        'Repeat for the desired number of reps.',
      ],
      video: 'https://www.youtube.com/watch?v=UgKaDSA3uIg',
    ),
  ];

  // The getAllExercises method is used to get all exercises.
  static List<Exercise> getAllExercises() {
    return ExerciseService.exercises;
  }
}
