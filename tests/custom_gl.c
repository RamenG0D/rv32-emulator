
#include "custom_gl.h"

/// This macro inserts the assembly code to make a draw call to the rust code
/// it does NOT clobber any registers
/// and the VA_ARGS is all the extra assembly code that the user wants to add (occurs just before we make our ebreak)
/// `mode` should be a `DRAW_*` macro
#define DRAW_CALL(mode, ...) \
    asm volatile ( \
        /* now set the values of the registers to our C function arguments*/ \
        "li a0, 1\n" /* set the ecall code to 1 (set pixel) */ \
        "li a1, " mode "\n" /* set the drawkind to `mode` */ \
        : /* no outputs */ \
        : /* no inputs */ \
        : "a0", "a1" /* clobbers */ \
    ); \
    asm volatile ( \
        /* this is where we let the user add the own operands and stuff */ \
        __VA_ARGS__ \
    ); \
    asm volatile ( \
        /* now make the "ecall" (really its an ebreak bu we check for stuff so its kinda the same) which will be caught by the rust code */ \
        "ebreak\n" \
        : /* no outputs */ \
        : /* no inputs */ \
        : "a0", "a1" /* clobbers */ \
    );

#define STRINGIFY(x) #x

#define DRAW_PIXEL  STRINGIFY(0)
#define DRAW_RECT   STRINGIFY(1)
#define DRAW_CIRCLE STRINGIFY(2)
#define DRAW_LINE   STRINGIFY(3)

// should convert the Color (literally just a struct representing 4 unsigned bytes) into a u32
int color_to_word(Color c) {
    union { Color c; int w; } u = {c};
    return u.w;
}

// stops the cpu's execution and signals to the rust code that we are done rendering and that it should update the screen (stop execution to allow raylib-rs to update the screen)
void render(void) {
    asm volatile (
        // set a0 to 0
        "li a0, 0\n"
        // now we ebreak to signal to the rust code that we are done
        "ebreak\n"
        : // no outputs
        : // no inputs
        : "a0" // clobbers
    );
}

// just a standard draw line function
void draw_line(int x1, int y1, int x2, int y2, Color c) {
    // now we make a draw call with the mode being 3 (draw line)
    DRAW_CALL(
        DRAW_LINE,
        "mv a2, %0\n"
        "mv a3, %1\n"
        "mv a4, %2\n"
        "mv a5, %3\n"
        "mv a6, %4\n"
        : // no outputs
        : "r"(x1), "r"(y1), "r"(x2), "r"(y2), "r"(color_to_word(c))
        : "a0", "a1", "a2", "a3", "a4", "a5", "a6"
    );
}

// just a standard draw rectangle function
void draw_rect(int x, int y, int w, int h, Color c) {
    // now we make a draw call with the mode being 1 (draw rectangle)
    DRAW_CALL(
        DRAW_RECT,
        "mv a2, %0\n"
        "mv a3, %1\n"
        "mv a4, %2\n"
        "mv a5, %3\n"
        "mv a6, %4\n"
        : // no outputs
        : "r"(x), "r"(y), "r"(w), "r"(h), "r"(color_to_word(c))
        : "a0", "a1", "a2", "a3", "a4", "a5", "a6"
    );
}

// set the pixel at x, y to the color c
void set_pixel(int x, int y, Color c) {
    DRAW_CALL(
        DRAW_PIXEL,
        "mv a2, %0\n"
        "mv a3, %1\n"
        "mv a4, %2\n"
        : // no outputs
        : "r"(x), "r"(y), "r"(color_to_word(c))
        : "a0", "a1", "a2", "a3", "a4"
    );
}
