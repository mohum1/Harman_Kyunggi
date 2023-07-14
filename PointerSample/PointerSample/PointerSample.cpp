#include <stdio.h>
#include <malloc.h>

//int main()
//{
//    char c = 'A';       // %c
//    int i = 1;          // %d
//    float a = 2.0;      // %f
//    double d = 3.14;    // %(l)f
//    void *p = &i;       // 그저 주소일 뿐
//
//    printf("int i = %8d, [0x%08x]\n", *(int *)p, p);     // %08x : 8자리, 빈자리는 0
//    printf("int i = %8d, [0x%08x]\n", i, &i);
// 
// 
//}

//int main()
//{
//	double d = 3.14;
//	void *p = (void *)0x80000000;		// 그저 주소일 뿐
//	*(double *)p = d;					// 불가능
//
//	printf("p = %8f [0x%08x]\n", *(double *)p, p);
//
//}

//int main()
//{
//	double d = 3.14;
//	void *p = malloc(100);			// Heap 영역에 메모리 공간 확보
//		
//	*(double *)p = d;				
//
//	printf("p = %8f [0x%08x]\n", *(double *)p, p);
//
//}
char buf[2000];
void MemoryDump(int start, int length);	// 함수의 원형 Proto-type

int main(int argc, char *argv[])	// pointerSample 10000 500 : Command Line 명령어
{									// 10000 : Start memory 주소
									// 500	 : Dump할 memory 크기

	int start = 0x09000000;
	int length = 500;

	/*void *p = buf;
	*(int *)p = start;

	for (int i = 0; i < length; i++)
	{
		printf("p = %8d [0x%08x]\n", *(int *)p, buf[i]);
	}*/

	MemoryDump((int)buf, length); // char타입 buf를 int로

}

// 메모리덤프 : 화면 상에 메모리 데이터를 출력

void MemoryDump(int start, int length)
{
	char *cp = buf;
	//void *vp = (void *)start;
	int i = 0;						// index 변수 초기값
	while (i < length)				// 수행조건 i < length
	{
		unsigned char c = *((char *)cp + i++);	//char *cp = (char *)vp; 
		//char c = *cp;
		printf("%02x ", c);
	}
}





