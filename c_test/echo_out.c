
#include "debug.h"

int main(void) {
    while (1) {
        while ((UART(5) & 1) == 0);
        char c = UART(0);
        if ('a' <= c && c <= 'z') {
            c = c + 'A' - 'a';
        }
        UART(0) = c;
    }
    return 0;
}
