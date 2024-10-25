#include "custom_gl.h"

#define WHITE ( (Color){255, 255, 255, 255} )
#define BLACK ( (Color){0, 0, 0, 255} )
#define RED ( (Color){255, 0, 0, 255} )
#define GREEN ( (Color){0, 255, 0, 255} )
#define BLUE ( (Color){0, 0, 255, 255} )
#define YELLOW ( (Color){255, 255, 0, 255} )
#define CYAN ( (Color){0, 255, 255, 255} )
#define MAGENTA ( (Color){255, 0, 255, 255} )

#define loop while(true)

#define SW 600
#define SH 600

int main(void) {
    // make a large portion of the screen white
    loop {
        // draw a white rectangle over the whole screen
        draw_rect(0, 0, SW, SH, WHITE);

        // draw a white line from the top left to the bottom right
        draw_line(0, 0, SW, SH, RED);

        render();
    }

    return 0;
}
