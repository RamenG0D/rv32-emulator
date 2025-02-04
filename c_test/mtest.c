
#include "debug.h"

// test custom memory allocation (no stdlib)
// also no kernel or syscalls :(
int main(void) {
	// memcpy a string into the memory
	printf("malloc test\n");
	{
		char* str = (char*)malloc(sizeof(char)*40);
		if(!str) {
			printf("malloc failed\n");
			return 1;
		}
		const char* test = "hey there!";
		const int test_len = strlen(test);
		memcpy(str, test, test_len);
		printf("\t%s\n", str);
		free(str);
	}
	printf("malloc test passed\n");

	printf("calloc test\n");
	{
		char* str = (char*)calloc(11, sizeof(char));
		if(!str) {
			printf("calloc failed\n");
			return 1;
		}
		const char* test = "hey where!";
		const int test_len = strlen(test);
		memcpy(str, test, test_len);
		printf("\t%s\n", str);
		free(str);
	}
	printf("calloc test passed\n");

	// now testing custom string
	printf("string test\n");
	{
		string* s = string_new("isn't doom great?");
		if(!s) {
			printf("\tstring_new failed\n");
			return 1;
		}
		printf("\t%s\n", s->data);
		free_str(s);
	}
	printf("string test passed\n");

	// now testing string_new_len
	printf("string_new_len test\n");
	{
		const char* test = "this is a test";
		const int test_len = strlen(test);
		string* s2 = string_new_len(test, test_len);
		printf("\t%s\n", s2->data);
		free_str(s2);
	}
	printf("string_new_len test passed\n");

	{
		// now trying multi demensional arrays
		string* array[2];
		// we must accually allocate the array members aswell
		array[0] = string_new("have you");
		array[1] = string_new("prayed today?");
		printf("\t%s\n", array[0]->data);
		printf("\t%s\n", array[1]->data);
		// and now we must free the array members
		free_str(array[0]);
		free_str(array[1]);
		// and we dont malloc the array itself its stack allocated
		// so we dont need to free it
		// free(array);
	}

	{
		// realloc testing
		string* s = string_new("this is a test");
		printf("\t%s\n", s->data);
		// append this string to the end
		string_append(s, " I AM BATMAN!");

		printf("\t%s\n", s->data);

		free_str(s);
	}

	// now we debug the heap
	debug_heap();

	return 0;
}
