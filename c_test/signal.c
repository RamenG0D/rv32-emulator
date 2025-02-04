#include <stddef.h>

// #define DEBUG

#ifdef DEBUG
#define debug printf
#else
#define debug(...)
#endif

// this is a library to implement custom versions of the singal functions

typedef void (*sighandler_t)(int);

sighandler_t signal(int signum, sighandler_t handler) {
	(void)signum;
	(void)handler;
	return NULL;
}

int raise(int signum) {
	(void)signum;
	return 0;
}
