#ifndef GL_CUSTOM_H
#define GL_CUSTOM_H

#define true 1
#define false 0

typedef struct {
    unsigned char r;
    unsigned char g;
    unsigned char b;
    unsigned char a;
} Color;

#define PRESERVE_REGISTER(reg) \
    "addi sp, sp, -8\n" \
    "sw " #reg ", 0(sp)\n"

#define RESTORE_REGISTER(reg) \
    "lw " #reg ", 0(sp)\n" \
    "addi sp, sp, 8\n"

int color_to_word(Color c);
void set_pixel(int, int, Color);
void draw_rect(int x, int y, int w, int h, Color c);
void draw_line(int x1, int y1, int x2, int y2, Color c);
// void draw_circle(int x, int y, int r, Color c); // TODO: implement draw_circle
void render(void) __attribute__((naked));

#endif // GL_CUSTOM_H