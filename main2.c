#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int arr[100];

int main() {

	unsigned n = 0;
	(void)scanf("%u", &n);

	unsigned int i = 0;

cycle1_start:
	if (i == n) goto cycle1_end;
	(void)scanf("%d", &arr[i]);
	++i;
	goto cycle1_start;

cycle1_end:

	i = 0;
	printf("the source array: ");

cycle2_start:
	if (i == n) goto cycle2_end;
	printf("%d ", arr[i]);
	++i;
	goto cycle2_start;

cycle2_end:

	i = 0;
	printf("\nlet's sort it out...");

	unsigned left = 0;
	unsigned right = n - 1;
	unsigned last_swap = 0;
	int tmp = 0;

cycle3_start:
	if (left >= right) goto cycle3_end;

cycle3d1_start:
	if (i == right) goto cycle3d1_end;
	if (arr[i + 1] < arr[i]) goto swap1;
	i++;
	goto cycle3d1_start;

swap1:
	tmp = arr[i + 1];
	arr[i + 1] = arr[i];
	arr[i] = tmp;
	last_swap = i;
	i++;
	goto cycle3d1_start;

cycle3d1_end:
	right = last_swap;
	i = right;

cycle3d2_start:
	if (i == left) goto cycle3d2_end;
	if (arr[i] < arr[i - 1]) goto swap2;
	i--;
	goto cycle3d2_start;

swap2: 
	tmp = arr[i];
	arr[i] = arr[i - 1];
	arr[i - 1] = tmp;
	last_swap = i;
	i--;
	goto cycle3d2_start;

cycle3d2_end:
	left = last_swap;
	i = left;

	goto cycle3_start;

cycle3_end:

	printf("\nsorted array: ");
	i = 0;

cycle4_start:
	if (i == n) goto cycle4_end;
	printf("%d ", arr[i]);
	++i;
	goto cycle4_start;

cycle4_end:

	return 0;
}