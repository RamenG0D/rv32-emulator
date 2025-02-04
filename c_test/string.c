#include "debug.h"

// custom strlen implementation
size_t strlen(const char* str) {
	size_t i = 0;
	while(str[i] != '\0') {
		i++;
	}
	return i;
}

// custom strcmp implementation
int strcmp(const char* s1, const char* s2) {
	while(*s1 && (*s1 == *s2)) {
		s1++;
		s2++;
	}
	return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

// custom strchr implementation
char* strchr(const char* s, int c) {
	while(*s) {
		if(*s == c) {
			return (char*)s;
		}
		s++;
	}
	return NULL;
}

// custom strcpy implementation
char* strcpy(char* dest, const char* src) {
	char* d = dest;
	while(*src) {
		*d = *src;
		d++;
		src++;
	}
	*d = '\0';
	return dest;
}

// custom strcat implementation
char* strcat(char* dest, const char* src) {
	char* d = dest;
	while(*d) d++;

	while(*src) {
		*d = *src;
		d++;
		src++;
	}
	*d = '\0';
	return dest;
}

// custom strstr implementation
char* strstr(const char* haystack, const char* needle) {
	while(*haystack) {
		if(strcmp(haystack, needle) == 0) {
			return (char*)haystack;
		}
		haystack++;
	}
	return NULL;
}

// this function may take a non null terminated string
// or a non null terminated string
// either way it produces a string object which is not null terminated
// and we just use our length property to keep track of the length
string* string_new_len(const char* data, size_t length) {
	string* str = malloc(sizeof(string));
	if(!str) {
		return NULL;
	}
	str->data = malloc(length + 1);
	if(!str->data) {
		free(str);
		return NULL;
	}
	memcpy(str->data, data, length);
	str->length = length;
	str->capacity = length + 1;

	return str;
}

// data must be null terminated
// otherwise use string_new_len
string* string_new(const char* data) {
	return string_new_len(data, strlen(data));
}

void string_grow(string* str, size_t new_capacity) {
	if(new_capacity <= str->capacity) {
		return;
	}
	char* new_data = malloc(new_capacity);
	if(!new_data) {
		return;
	}
	memcpy(new_data, str->data, str->length);
	free(str->data);
	str->data = new_data;
	str->capacity = new_capacity;
}

// shinks the capacity to the length + 1
// this is useful if you know that the string will not grow anymore
void string_shrink(string* str) {
	string_grow(str, str->length + 1);
}

// produces a full copy of a string
// (a deep copy) so that the original string
// can be modified without affecting the copy (and vice versa)
string* string_copy(string* str) {
	return string_new_len(str->data, str->length);
}

void string_append_len(string* str, const char* data, size_t length) {
	if(str->length + length >= str->capacity) {
		size_t new_capacity = str->capacity * 2;
		if(new_capacity < str->length + length) {
			new_capacity = str->length + length;
		}
		string_grow(str, new_capacity);
	}
	memcpy(str->data + str->length, data, length);
	str->length += length;
	str->data[str->length] = '\0';
}

void string_append(string* str, const char* data) {
	string_append_len(str, data, strlen(data));
}

void string_append_char(string* str, char c) {
	if(str->length + 1 >= str->capacity) {
		size_t new_capacity = str->capacity * 2;
		if(new_capacity < str->length + 1) {
			new_capacity = str->length + 1;
		}
		string_grow(str, new_capacity);
	}
	str->data[str->length] = c;
	str->length++;
	str->data[str->length] = '\0';
}

char *string_data(string *str) {
    // we need to add a null terminator to the string
    string_append_char(str, '\0');
    // return the buffer
    return str->data;
}

void free_str(string* str) {
	free(str->data);
	free(str);
}
