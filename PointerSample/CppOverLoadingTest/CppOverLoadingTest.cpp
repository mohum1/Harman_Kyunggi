#include <stdio.h>
#define SQUARE(X) ((X)*(X))
#define ABS(X) ((X)<0)?-(X):(X)

//int abs(int val);
//float abs(float val);	// �Լ� �����ε� : ���� �Լ���, �ٸ� argument �ٸ� return
void swap(int &a, int &b);
void swap_p(int *a, int *b);
void swap_val(int a, int b);

int main()
{
	int i = -100;
	int j = 100;
	float a = -2.0;

	printf("�ʱⰪ a = %d, b = %d\n", i, j);	// ���� ������
	//swap_val(i, j);
	//printf("a = %d, b = %d\n", i, j);	// call by value : ���������̱� ������ swap ������ �ȵ�
	swap(i, j);
	printf("a = %d, b = %d\n", i, j);	// call by reference 

	/*printf("��ũ���Լ��� ������ ���� %f\n", SQUARE(3.15));
	printf("i�� ���밪 %d\n", ABS(-5));
	printf("a�� ���밪 %f\n", ABS(a));*/
}

void swap(int &a, int &b)				// call-by-reference : reference Ÿ������ ����, ����� ���ÿ� �ʱ�ȭ
{	
	int c = a;
	printf("--------call-by-reference in swap--------\n");
	a = b; b = c;
}
void swap_p(int *a, int *b)				// call by reference : �ּ�, ������
{
	int c = *a;
	printf("--------call-by-reference in swap--------\n");
	*a = *b; *b = c;
	printf("a = %d, b = %d\n", *a, *b);	// ó�� �� ������
}
void swap_val(int a, int b)				// call by value
{
	int c = a;
	printf("--------in swap--------\n");
	a = b; b = c;
	printf("a = %d, b = %d\n", a, b);	// ó�� �� ������
}
int abs(int val)	// argument val�� ���밪 ��ȯ
{
	//if (val < 0) return -val;
	//return val;
	return (val < 0) ? -val : val;
}
float abs(float val)	// argument val�� ���밪 ��ȯ
{
	//if (val < 0) return -val;
	//return val;
	return (val < 0) ? -val : val;
}
