import 'dart:math';

double generateGaussianRandomNumber(double mean, double standardDeviation) {
  final random = Random();
  double u1 = random.nextDouble(); // Uniform(0,1) random number
  double u2 = random.nextDouble(); // Uniform(0,1) random number
  double z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2); // Box-Muller transform
  return z0 * standardDeviation + mean;
}

double generateGaussianRandomNumberInRange(
    double mean, double standardDeviation, double min, double max) {
  double number;
  do {
    number = generateGaussianRandomNumber(mean, standardDeviation);
  } while (number < min || number > max);
  return number;
}
