#include <stdio.h>

int arr[100];

int main() {
	
	unsigned n = 0;
	(void)scanf("%u", &n);

	for (unsigned i = 0; i < n; ++i) {
		(void)scanf("%d", &arr[i]);
	}

	printf("the source array: ");
	for (unsigned i = 0; i < n; ++i) {
		printf("%d ", arr[i]);
	}

	printf("\nlet's sort it out...");	

	unsigned left = 0, right = n - 1;
	unsigned last_swap = 0;
	while (left < right)
	{
		for (unsigned i = left; i < right; ++i) {
			if (arr[i + 1] < arr[i]) {
				int tmp = arr[i];
				arr[i] = arr[i + 1];
				arr[i + 1] = tmp;
				last_swap = i;
			}
		}
		right = last_swap;

		for (unsigned j = right; j > left; --j) {
			if (arr[j] < arr[j - 1]) {
				int tmp = arr[j];
				arr[j] = arr[j - 1];
				arr[j - 1] = tmp;
				last_swap = j;
			}
		}
		left = last_swap;
	}

	printf("\nsorted array: ");
	for (unsigned i = 0; i < n; ++i) {
		printf("%d ", arr[i]);
	}

	return 0;
}