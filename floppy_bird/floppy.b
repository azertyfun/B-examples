/*
 * FLOPPY BIRD
 * A game by Azertyfun
 * Made in B, graciously provided by Blecki
 * Structure inspired by Blecki's spacesnake (https://github.com/Blecki/DCPUB/blob/master/Binaries/techcompliant/spacesnake.b)
 */

#include hardware.b
#include lem.b
#include keyboard.b
#include random.b

#define WIDTH 32
#define HEIGHT 12
#define SIZE 384

#define SPACE_BETWEEN_PIPES 2
#define MIN_PIPE_LENGTH 3
#define MAX_PIPE_LENGTH 7

#define PIPE_CHAR 0xC01B
#define floppy_CHAR 0xE001

//static gameover = "   @@@    @   @   @ @@@@        " +
//                  "  @      @ @  @@ @@ @           " +
//                  "  @ @@  @ @ @ @ @ @ @@@@        " +
//                  "  @   @ @   @ @   @ @           " +
//                  "   @@@  @   @ @   @ @@@@        " +
//                  "                                " +
//                  " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ " +
//                  "           @@@  @   @ @@@@ @@@  " +
//                  "          @   @ @   @ @    @  @ " +
//                  "          @   @  @ @  @@@@ @@@  " +
//                  "          @   @  @ @  @    @ @  " +
//                  "           @@@    @   @@@@ @  @ ";

local gameover = "   @@@    @   @   @ @@@@          @      @ @  @@ @@ @             @ @@  @ @ @ @ @ @ @@@@          @   @ @   @ @   @ @              @@@  @   @ @   @ @@@@                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            @@@  @   @ @@@@ @@@            @   @ @   @ @    @  @           @   @  @ @  @@@@ @@@            @   @  @ @  @    @ @             @@@    @   @@@@ @  @ ";


static font[256] = {
0xFF00, 0x00FF, 0x183C, 0x541C, 0x08F8, 0x0808, 0x00FF, 0x0808,
0x0808, 0x0808, 0x08FF, 0x0808, 0x00FF, 0x1414, 0xFF00, 0xFF08,
0x1F10, 0x1714, 0xFC04, 0xF414, 0x1710, 0x1714, 0xF404, 0xF414,
0xFF00, 0xF714, 0x1414, 0x1414, 0xF700, 0xF714, 0x1417, 0x1414,
0x0F08, 0x0F08, 0x14F4, 0x1414, 0xF808, 0xF808, 0x0F08, 0x0F08,
0x001F, 0x1414, 0x00FC, 0x1414, 0xF808, 0xF808, 0xFF08, 0xFF08,
0x14FF, 0x1414, 0x080F, 0x0000, 0x00F8, 0x0808, 0xFFFF, 0xFFFF,
0xF0F0, 0xF0F0, 0xFFFF, 0x0000, 0x0000, 0xFFFF, 0x0F0F, 0x0F0F,
0x0000, 0x0000, 0x005f, 0x0000, 0x0300, 0x0300, 0x3e14, 0x3e00,
0x266b, 0x3200, 0x611c, 0x4300, 0x3629, 0x7650, 0x0002, 0x0100,
0x1c22, 0x4100, 0x4122, 0x1c00, 0x1408, 0x1400, 0x081c, 0x0800,
0x4020, 0x0000, 0x0808, 0x0800, 0x0040, 0x0000, 0x601c, 0x0300,
0x3e49, 0x3e00, 0x427f, 0x4000, 0x6259, 0x4600, 0x2249, 0x3600,
0x0f08, 0x7f00, 0x2745, 0x3900, 0x3e49, 0x3200, 0x6119, 0x0700,
0x3649, 0x3600, 0x2649, 0x3e00, 0x0024, 0x0000, 0x4024, 0x0000,
0x0814, 0x2200, 0x1414, 0x1400, 0x2214, 0x0800, 0x0259, 0x0600,
0x3e59, 0x5e00, 0x7e09, 0x7e00, 0x7f49, 0x3600, 0x3e41, 0x2200,
0x7f41, 0x3e00, 0x7f49, 0x4100, 0x7f09, 0x0100, 0x3e41, 0x7a00,
0x7f08, 0x7f00, 0x417f, 0x4100, 0x2040, 0x3f00, 0x7f08, 0x7700,
0x7f40, 0x4000, 0x7f06, 0x7f00, 0x7f01, 0x7e00, 0x3e41, 0x3e00,
0x7f09, 0x0600, 0x3e61, 0x7e00, 0x7f09, 0x7600, 0x2649, 0x3200,
0x017f, 0x0100, 0x3f40, 0x7f00, 0x1f60, 0x1f00, 0x7f30, 0x7f00,
0x7708, 0x7700, 0x0778, 0x0700, 0x7149, 0x4700, 0x007f, 0x4100,
0x031c, 0x6000, 0x417f, 0x0000, 0x0201, 0x0200, 0x8080, 0x8000,
0x0001, 0x0200, 0x2454, 0x7800, 0x7f44, 0x3800, 0x3844, 0x2800,
0x3844, 0x7f00, 0x3854, 0x5800, 0x087e, 0x0900, 0x4854, 0x3c00,
0x7f04, 0x7800, 0x047d, 0x0000, 0x2040, 0x3d00, 0x7f10, 0x6c00,
0x017f, 0x0000, 0x7c18, 0x7c00, 0x7c04, 0x7800, 0x3844, 0x3800,
0x7c14, 0x0800, 0x0814, 0x7c00, 0x7c04, 0x0800, 0x4854, 0x2400,
0x043e, 0x4400, 0x3c40, 0x7c00, 0x1c60, 0x1c00, 0x7c30, 0x7c00,
0x6c10, 0x6c00, 0x4c50, 0x3c00, 0x6454, 0x4c00, 0x0836, 0x4100,
0x0077, 0x0000, 0x4136, 0x0800, 0x0201, 0x0201, 0x0205, 0x0200};

static vram = __endofprogram; // First free word in RAM
static buffer = __endofprogram;
buffer = buffer + SIZE;

local lem = detect_hardware(LEM_HARDWARE_ID);
lem_initialize(lem, vram);
asm (B = font; C = lem) // Set the font
{
    SET A, 1
    HWI C
}

local keyboard = detect_hardware(GENERIC_KEYBOARD_ID);

local floppy_y = 4;
local floppy_isGoingUp = false;
local floppy_goingUp_ticks = 0; // How many loops has floppy been going up? --- Used to determine if we should make floppy go down instead.

static pipes_pos[3] = {10, 20, 30};

//These two arrays control how long each pipe is. In floppy bird, pipes are of random size, but with always the same space in between them; so the bottom length is just (HEIGHT - topLength - SPACE_BETWEEN_PIPES)
static pipes_length[3];
local i = 0;
while(i < 3) {
    pipes_length[i] = MIN_PIPE_LENGTH + random() % (MAX_PIPE_LENGTH - MIN_PIPE_LENGTH);
    i = i + 1;
}

clear(buffer);
clear(vram);

local playing = 1;

while(playing) {
    floppy_goingUp_ticks = floppy_goingUp_ticks + 1;

    // Change floppy direction
    local key = kb_getkey(keyboard);
    if(key == 0x20) { //0x20 is space
        floppy_isGoingUp = true;
        floppy_goingUp_ticks = 0;
    } else if(floppy_isGoingUp) {
        if(floppy_goingUp_ticks == 4) { // Apparently there is no && operator
            floppy_isGoingUp = false;
        }
    }

    // Update floppy position
    if(floppy_isGoingUp == 1) {
        if(floppy_y > 1) {
            floppy_y = floppy_y - 1;
        }
    } else if(floppy_isGoingUp == 0) {
        if(floppy_y < HEIGHT) {
            floppy_y = floppy_y + 1;
        }
    }

    // Move the pipes
    i = 0;
    while(i < 3) {
        pipes_pos[i] = pipes_pos[i] - 1;

        if(pipes_pos[i] == 0xFFFF) {
            pipes_pos[i] = WIDTH;
            pipes_length[i] = MIN_PIPE_LENGTH + random() % (MAX_PIPE_LENGTH - MIN_PIPE_LENGTH);
        }

        i = i + 1;
    }

    //Check colision
    i = 0;
    while(i < 3) {
        if(pipes_pos[i] == 1) {
            if(floppy_y < pipes_length[i]) {
                playing = false;
            } else if(floppy_y > pipes_length[i] + SPACE_BETWEEN_PIPES - 1) {
                playing = false;
            }
        }

        i = i + 1;
    }

    buffer[floppy_y * WIDTH + 1] = floppy_CHAR;
    render_pipes(PIPE_CHAR);

    swapBufferWithVram(lem);
}

clear(vram);
i = 0;
while(i < SIZE) {
    local color = random();

    vram[i] = gameover[i + 1] | (color << 12);
    i = i + 1;
}

while(true) {

}

function swapBufferWithVram(lem) {
    local tmp = buffer;
    buffer = vram;
    vram = tmp;

    lem_initialize(lem, vram);

    clear(buffer);
}

function clear(target_buffer) {
    local i = 0;
    while(i < SIZE) {
        target_buffer[i] = 0;
        i = i + 1;
    }
}

function render_pipes(character) {
    local i = 0;
    while(i < 3) {
        local j = 0;
        while(j < pipes_length[i]) {
            buffer[pipes_pos[i] + 0x20 * j] = character;
            j = j + 1;
        }

        j = 0;
        while(j < HEIGHT - SPACE_BETWEEN_PIPES - pipes_length[i] + 1) {
            buffer[pipes_pos[i] + WIDTH*HEIGHT - 0x20 * j] = character;
            j = j + 1;
        }

        i = i + 1;
    }
}
