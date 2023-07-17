#include <stdio.h>
#define SQUARE(X) ((X)*(X))
#define ABS(X) ((X)<0)?-(X):(X)

//int abs(int val);
//float abs(float val);	// 함수 오버로딩 : 같은 함수명, 다른 argument 다른 return
void swap(int &a, int &b);
void swap_p(int *a, int *b);
void swap_val(int a, int b);

int main()
{
	int i = -100;
	int j = 100;
	float a = -2.0;

	printf("초기값 a = %d, b = %d\n", i, j);	// 원본 데이터
	//swap_val(i, j);
	//printf("a = %d, b = %d\n", i, j);	// call by value : 지역변수이기 때문에 swap 적용이 안됨
	swap(i, j);
	printf("a = %d, b = %d\n", i, j);	// call by reference 

	/*printf("매크로함수로 제곱값 도출 %f\n", SQUARE(3.15));
	printf("i의 절대값 %d\n", ABS(-5));
	printf("a의 절대값 %f\n", ABS(a));*/
}

void swap(int &a, int &b)				// call-by-reference : reference 타입으로 받음, 선언과 동시에 초기화
{	
	int c = a;
	printf("--------call-by-reference in swap--------\n");
	a = b; b = c;
}
void swap_p(int *a, int *b)				// call by reference : 주소, 포인터
{
	int c = *a;
	printf("--------call-by-reference in swap--------\n");
	*a = *b; *b = c;
	printf("a = %d, b = %d\n", *a, *b);	// 처리 후 데이터
}
void swap_val(int a, int b)				// call by value
{
	int c = a;
	printf("--------in swap--------\n");
	a = b; b = c;
	printf("a = %d, b = %d\n", a, b);	// 처리 후 데이터
}
int abs(int val)	// argument val의 절대값 반환
{
	//if (val < 0) return -val;
	//return val;
	return (val < 0) ? -val : val;
}
float abs(float val)	// argument val의 절대값 반환
{
	//if (val < 0) return -val;
	//return val;
	return (val < 0) ? -val : val;
}
