#include "debug.h"

const char* get_msg(const char* nmsg);

int main(void) {
	printf("Message: {%s}\n", get_msg(NULL));
	printf("Message: {%s}\n", get_msg("Goodbye, world!"));
	printf("Number: {%f}\n", 100.4);

	return 0;
}

const char* get_msg(const char* nmsg) {
	static const char* global_string = "Hello, world!";
	if(nmsg) {
		global_string = nmsg;
	}
	return global_string;
}
