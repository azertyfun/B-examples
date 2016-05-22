/*
 * Nyan Cat
 * A game by Azertyfun
 * Made in B, graciously provided by Blecki
 */


// Blecki's libs make it easier to use the LEM
#include hardware.b
#include lem.b

// Contains the animation and the sound data
#include nyancat_data.b

// Used by the detect_hardware routine.
static SPEAKER_ID[2] = {0xC0F0, 0x0001};

// We set the font and palette to display the animation.
local lem = detect_hardware(LEM_HARDWARE_ID);
asm (B = font; C = lem)
{
    SET A, 1
    HWI C
}
asm(B = palette; C = lem)
{
    SET A, 2
    HWI C
}

// We detect the speaker
local speaker = detect_hardware(SPEAKER_ID);

local image_offset = 0;
local image_duration = 0;
local note_offset = 0;
local note_duration = 0;
while(true) {

    /*
     * To display the animation, the intuitive approach would be to copy each frame to the VRAM. However, this would take a very long time, and the user would see each frame appear slowly before his eyes.
     * So, if we can't bring the frame to the vram, we'll bring the vram to the frame! We set the vram to (tiles + current_frame * SIZE_OF_SCREEN).
     */

    lem_initialize(lem, tiles + image_offset);

    if(image_duration > 10) {
        image_offset = image_offset + 0x180;
        if(image_offset > 4607) {
            image_offset = 0;
        }

        image_duration = 0;
    } else {
        image_duration = image_duration + 1;
    }

    /*
     * Here we play each note from the notes array, for a number of loops specified by the times array.
     */

    asm(B = notes[note_offset], C = speaker) {
        SET A, 0
        HWI C
    }

    if(durations[note_offset] == 0) {
        note_offset = note_offset + 1;
    } else if(note_duration != durations[note_offset]) {
        if(note_offset > 741) {
            note_offset = 0;
        }

        note_duration = note_duration + 1;
    } else {
        note_offset = note_offset + 1;
        note_duration = 0;
    }
}
