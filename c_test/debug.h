// This contains the debug functions for the C test programs
// and for the asm test programs

#ifndef DEBUG_H
#define DEBUG_H

#define UART(offset) (*(volatile char *)(0x10000000 + (offset)))

///////////////////////////////////////////////////////////////////////////////
// \author (c) Marco Paland (info@paland.com)
//             2014-2019, PALANDesign Hannover, Germany
//
// \license The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// \brief Tiny printf, sprintf and snprintf implementation, optimized for speed
// on
//        embedded systems with a very limited resources.
//        Use this instead of bloated standard/newlib printf.
//        These routines are thread safe and reentrant.
//
///////////////////////////////////////////////////////////////////////////////

#include <stdarg.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

char *get_string(void);
int *str2int(const char *str, int base);

// string functions
typedef struct string {
    char *data;
    size_t length;
    size_t capacity;
} string;

string *string_new(const char *data);
string *string_new_len(const char *data, size_t length);
void string_append(string *str, const char *data);
void string_append_len(string *str, const char *data, size_t length);
void string_append_char(string *str, char c);
void string_grow(string *str, size_t size);
void string_shrink(string *str);
char *string_data(string *str);
void free_str(string *str);
size_t strlen(const char *str);

// std string functions
int strcmp(const char *str1, const char *str2);
char *strcpy(char *dest, const char *src);
char *strcat(char *dest, const char *src);
char *strchr(const char *str, int character);
char *strstr(const char *str1, const char *str2);

#define noinline_attr __attribute__((noinline))

// memory functions
void *malloc(size_t size) noinline_attr;
void *realloc(void *ptr, size_t size) noinline_attr;
void *calloc(size_t nmemb, size_t size) noinline_attr;
void free(void *ptr) noinline_attr;
void *memset(void *ptr, int value, size_t length) noinline_attr;
void *memcpy(void *dest, const void *src, size_t n) noinline_attr;
void *memmove(void *dest, const void *src, size_t n) noinline_attr;
int memcmp(const void *s1, const void *s2, size_t n) noinline_attr;

// custom implementations of the C standard library functions
void abort(void);
void exit(int status);
int atexit(void (*func)(void));

// custom implementations of the C signal handling functions
typedef int sig_atomic_t;
#define SIG_DFL ((void (*)(int))0)
#define SIG_ERR ((void (*)(int)) - 1)
#define SIG_IGN ((void (*)(int))1)
#define SIGABRT 1
#define SIGFPE 2
#define SIGILL 3
#define SIGINT 4
#define SIGSEGV 5
#define SIGTERM 6
void (*signal(int sig, void (*func)(int)))(int);

// custom implementations of the C file I/O functions

typedef struct FILE FILE;
extern FILE *stdout;
extern FILE *stderr;
extern FILE *stdin;

#define EOF (-1)

FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
int fflush(FILE *stream);
int fgetc(FILE *stream);
char *fgets(char *str, int num, FILE *stream);
int fputc(int character, FILE *stream);
int fputs(const char *str, FILE *stream);
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t count, FILE *stream);
int fseek(FILE *stream, long int offset, int origin);
long int ftell(FILE *stream);
void rewind(FILE *stream);
int feof(FILE *stream);
int ferror(FILE *stream);
int fileno(FILE *stream);
int fprintf(FILE *stream, const char *format, ...);
int vfprintf(FILE *stream, const char *format, va_list arg);
int fscanf(FILE *stream, const char *format, ...);
int vfscanf(FILE *stream, const char *format, va_list arg);
int vsprintf(char *str, const char *format, va_list arg);
int vsscanf(const char *str, const char *format, va_list arg);
FILE *popen(const char *command, const char *mode);
int pclose(FILE *stream);

// pthread function declarations
#define EINVAL 1
#define EAGAIN 2
#define EBUSY 3
#define EDEADLK 4
#define EPERM 5
#define ESRCH 6

typedef unsigned long int pthread_t;
typedef unsigned int pthread_key_t;

struct __pthread_mutex_s
{
  int __lock;
  unsigned int __count;
  int __owner;
  /* KIND must stay at this position in the structure to maintain
     binary compatibility with static initializers.  */
  int __kind;
};

typedef union
{
  struct __pthread_mutex_s __data;
  char __size[32];
  long int __align;
} pthread_mutex_t;

typedef struct pthread_attr pthread_attr_t;

int pthread_create(pthread_t *thread, const void *attr,
                   void *(*start_routine)(void *), void *arg);
int pthread_kill(pthread_t thread, int sig);
int pthread_join(pthread_t thread, void **retval);
pthread_t pthread_self(void);

int pthread_key_create(pthread_key_t *key, void (*destructor)(void *));
int pthread_key_delete(pthread_key_t key);

int pthread_mutex_init(pthread_mutex_t *mutex, const void *attr);
int pthread_mutex_destroy(pthread_mutex_t *mutex);
int pthread_mutex_trylock(pthread_mutex_t *mutex);
int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);

int pthread_setspecific(pthread_key_t key, const void *value);
void* pthread_getspecific(pthread_key_t key);

// custom implementations of the C setjmp/longjmp functions
typedef int __jmpbuf[6];
#define _SIGSET_NWORDS (1024 / (8 * sizeof (unsigned long int)))
typedef struct
{
  unsigned long int __val[_SIGSET_NWORDS];
} __sigset_t;
struct __jmp_buf_tag {
    /* NOTE: The machine-dependent definitions of `__sigsetjmp'
       assume that a `jmp_buf' begins with a `__jmp_buf' and that
       `__mask_was_saved' follows it.  Do not move these members
       or add others before it.  */
	__jmpbuf __jmpbuf;       /* Calling environment.  */
    int __mask_was_saved;    /* Saved the signal mask?  */
    __sigset_t __saved_mask; /* Saved signal mask.  */
};
typedef struct __jmp_buf_tag jmp_buf[1];

int _setjmp(struct __jmp_buf_tag env[1]);
void longjmp(struct __jmp_buf_tag env[1], int val);

int setjmp(jmp_buf env);

void debug_heap(void);

#define EXIT_FAILURE 1

/**
 * Output a character to a custom device like UART, used by the printf()
 * function This function is declared here only. You have to write your custom
 * implementation somewhere \param character Character to output
 */
void _putchar(char character);

/**
 * Tiny printf implementation
 * You have to implement _putchar if you use printf()
 * To avoid conflicts with the regular printf() API it is overridden by macro
 * defines and internal underscore-appended functions like printf_() are used
 * \param format A string that specifies the format of the output
 * \return The number of characters that are written into the array, not
 * counting the terminating null character
 */
#ifdef __GNUC__
__attribute__ ((format (__printf__, 1, 2)))
#endif
int printf(const char* format, ...);

/**
 * Tiny sprintf implementation
 * Due to security reasons (buffer overflow) YOU SHOULD CONSIDER USING
 * (V)SNPRINTF INSTEAD! \param buffer A pointer to the buffer where to store the
 * formatted string. MUST be big enough to store the output! \param format A
 * string that specifies the format of the output \return The number of
 * characters that are WRITTEN into the buffer, not counting the terminating
 * null character
 */
#ifdef __GNUC__
__attribute__ ((format (__printf__, 2, 3)))
#endif
int sprintf(char* buffer, const char* format, ...);

/**
 * Tiny snprintf/vsnprintf implementation
 * \param buffer A pointer to the buffer where to store the formatted string
 * \param count The maximum number of characters to store in the buffer,
 * including a terminating null character \param format A string that specifies
 * the format of the output \param va A value identifying a variable arguments
 * list \return The number of characters that COULD have been written into the
 * buffer, not counting the terminating null character. A value equal or larger
 * than count indicates truncation. Only when the returned value is non-negative
 * and less than count, the string has been completely written.
 */
#ifdef __GNUC__
__attribute__ ((format (__printf__, 3, 4)))
#endif
int  snprintf_(char* buffer, size_t count, const char* format, ...);

#ifdef __GNUC__
__attribute__ ((format (__printf__, 3, 0)))
#endif
int vsnprintf(char* buffer, size_t count, const char* format, va_list va);

/**
 * Tiny vprintf implementation
 * \param format A string that specifies the format of the output
 * \param va A value identifying a variable arguments list
 * \return The number of characters that are WRITTEN into the buffer, not
 * counting the terminating null character
 */
#ifdef __GNUC__
__attribute__ ((format (__printf__, 1, 0)))
#endif
int vprintf(const char* format, va_list va);

/**
 * printf with output function
 * You may use this as dynamic alternative to printf() with its fixed _putchar()
 * output \param out An output function which takes one character and an
 * argument pointer \param arg An argument pointer for user data passed to
 * output function \param format A string that specifies the format of the
 * output \return The number of characters that are sent to the output function,
 * not counting the terminating null character
 */
#ifdef __GNUC__
__attribute__ ((format (__printf__, 3, 4)))
#endif
int fctprintf(void (*out)(char character, void* arg), void* arg, const char* format, ...);

#ifdef __cplusplus
}
#endif

#endif