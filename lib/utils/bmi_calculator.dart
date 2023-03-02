// BMI Calculator class
class BMICalculator {
  // The calculateBMI method is used to calculate the BMI.
  static double calculateBMI(int height, int weight) {
    return weight / ((height / 100) * (height / 100));
  }

// The getBMICategory method is used to get the BMI category.
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
}
