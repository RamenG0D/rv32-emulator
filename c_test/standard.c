#include "debug.h"

#include <stdbool.h>

// char2int
static inline int char2int(char ch) { return ch - '0'; }

// str2int
int *str2int(const char *input, int base) {
    static int output = 0;
    bool negative = false;
    int value = 0;
    while (*input) {
        // check for '-' sign aswell and skip it then make the value negative
        // later
        if (*input == '-') {
            negative = true;
            input++;
            continue;
        }
        // check if the character is a valid digit
        if (*input >= '0' && *input <= '9') {
            value = value * base + char2int(*input);
        } else {
            printf("%s Is not a Number!\n", input);
            return NULL;
        }
        // move to the next character
        input++;
    }
    output = negative ? -value : value;
    return &output;
}

// gets a string / line from standard input
// and returns a buffer containing the string
// *NOTE* the buffer is allocated on the heap and its the callers responsibility
// to free it
char *get_string(void) {
    string *str = string_new("");

    // we need to read until we hit a newline
    // but also we need to make sure we dont overflow the buffer
    while (true) {
        // wait for user input
        while ((UART(5) & 1) == 0)
            ;
        // read the character
        char c = UART(0);
        // check if we hit enter
        if (c == '\n') {
            break;
        }
        // append the character to the string
        string_append_char(str, c);
    }

    // shrink the buffer to fit the actual string (so we dont waste memory)
    string_shrink(str);
    // get the string data
    char* data = string_data(str);
    // new we must free the string (niote we are not freeing the data /
    // underlying buffer)
    free(str);
    // return the string data
    return data;
}

// custom implementations of the C standard library functions

// custom exit implementation
void exit(int status) {
    // we will use a breakpoint to stop the program
    asm volatile("ebreak");

    // we should never get here
    (void)status;
    while (1)
        ;
}

// custom atexit implementation
int atexit(void (*func)(void)) {
    // we dont support atexit
    (void)func;
    return 0;
}

// custom implementations of the C standard library FILE struct

// stdin
FILE *stdin = NULL;

// stdout
FILE *stdout = NULL;

// stderr
FILE *stderr = NULL;

// custom implementations of the C standard library functions
// such as fopen, fclose, fread, fwrite, fprintf, fscanf

// custom fopen implementation
FILE *fopen(const char *filename, const char *mode) {
    (void)filename;
    (void)mode;
    return NULL;
}

// custom fclose implementation
int fclose(FILE *stream) {
    (void)stream;
    return 0;
}

// custom fread implementation
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    (void)ptr;
    (void)size;
    (void)nmemb;
    (void)stream;
    return 0;
}

// custom fwrite implementation
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream) {
    (void)ptr;
    (void)size;
    (void)nmemb;
    (void)stream;
    return 0;
}

// custom fprintf implementation
int fprintf(FILE *stream, const char *format, ...) {
    (void)stream;
    (void)format;
    return 0;
}

// custom fscanf implementation
int fscanf(FILE *stream, const char *format, ...) {
    (void)stream;
    (void)format;
    return 0;
}

// custom definition for __isoc99_vsscanf
int __isoc99_vsscanf(const char *str, const char *format, va_list ap) {
    (void)str;
    (void)format;
    (void)ap;
    return 0;
}

// custom definition for __isoc99_vfscanf
int __isoc99_vfscanf(const char *str, const char *format, va_list ap) {
    (void)str;
    (void)format;
    (void)ap;
    return 0;
}

// custom definition for vfscanf
int vfscanf(FILE *stream, const char *format, va_list ap) {
	(void)stream;
	(void)format;
	(void)ap;
	return 0;
}

// custom definition for vsscanf
int vsscanf(const char *str, const char *format, va_list ap) {
	(void)str;
	(void)format;
	(void)ap;
	return 0;
}

// custom definition for _setjmp
int _setjmp(struct __jmp_buf_tag env[1]) {
    (void)env;
    return 0;
}

int setjmp(jmp_buf env) {
	(void)env;
	return 0;
}

// custom definition for _longjmp
void longjmp(struct __jmp_buf_tag env[1], int val) {
	(void)env;
	(void)val;
	while(1);
}
