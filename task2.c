#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>

const double PI = 6.283185307;

int factorial(int n) {
	if (n == 0) return 1;
	return n * factorial(n - 1);
}

float cos_(double x) {
	x = fmod(x, PI);
	double a0 = 1.0;
	double tmp = a0;
	double result = 0.0;
	int i = 0;
	while (i <= 6) {
		result += pow(-1, i) * (pow(x, 2 * i) / factorial(i * 2));
		i++;
	}
	return result;
}

double cosine(double x) {
	
	double sum = 0.0;
	for (int n = 0; n < 10; n++) { // 10 членов ряда
		double term = (n % 2 == 0 ? 1 : -1) * (pow(x, 2 * n) / factorial(2 * n));
		sum += term;
	}
	return sum;
}

int main() {
	
	double angle = 50;
	printf("%f       ", cos(angle));
	printf("%.6f\n", cos_(angle));

	return 0;
}
