#include "rndtable.h"

#define MAXSTARS 	256
#define ZMAX		4096
#define SCREENDIST	256

struct star {
	int x;
	int y;
	int z;
	unsigned int screen_x;
	unsigned int screen_y;
	int speed;
};

static struct star stars[MAXSTARS];

struct screeninfo {
	int  xres;
	int  yres;
	char *screen;
};

static struct screeninfo screeninfo;

void update_star(struct star* star);
void create_star(struct star* star);

#if 0
static void set_pal(char *pal) {
	int s=0;
	unsigned short i;

	for (i = 0; i < 192; i += 3) {
		pal[i]   = s;
		pal[i+1] = 0;
		pal[i+2] = 0;
		s++;
	 }

	 s = 0;
	 for(i = 192; i < 384; i += 3) {
		pal[i] = 64;
		pal[i+1] = s;
		pal[i+2] = 0;
		s++;
	 }

	 s = 0;
	 for(i = 384; i < 576; i += 3) {
		pal[i]   = 64;
		pal[i+1] = 255;
		pal[i+2] = s;
		s++;
	 }

	 for(i = 576; i < 768; i++) {
		 pal[i]  = 255;
	 }
}
#else
static void set_pal(char *pal)
{
	int s=0;
	unsigned short i;
	for (i = 0; i < 192; i += 3) {
		pal[i]   = s;
		pal[i+1] = 0;
		pal[i+2] = s;
		s += 4;
	 }

	 s = 0;
	 for(i = 192; i < 384; i += 3) {
		pal[i]   = 255;
		pal[i+1] = s;
		pal[i+2] = 255 - s;
		s += 4;
	 }

	 s = 0;
	 for(i = 384; i < 576; i += 3) {
		pal[i]   = 255;
		pal[i+1] = 255;
		pal[i+2] = s;
		s += 4;
	 }

	 for(i = 576; i < 768; i++) {
		 pal[i]  = 255;
	 }

}
#endif

void delete_star(struct star* star)
{
	if ((star->screen_x >= 0 && star->screen_x < screeninfo.xres) &&
	    (star->screen_y >= 0 && star->screen_y < screeninfo.yres)) {
		screeninfo.screen[star->screen_x +
				  star->screen_y*screeninfo.xres] = 0;
	}
}

void update_star(struct star* star)
{
	/* calculate new screen coordinates */
	star->screen_x = (star->x*256)/star->z + screeninfo.xres/2;
	star->screen_y = (star->y*256)/star->z + screeninfo.yres/2;
	/* check boundaries, and replace the star if we are outside them */
	if ((0 >= star->z) || (star->screen_x >= screeninfo.xres-2) ||
	    (star->screen_y >= screeninfo.yres-2)|| (star->screen_x <= 2) ||
	    (star->screen_y <= 2)) {
		create_star(star);
		update_star(star);
	}

	/* and draw star */
	screeninfo.screen[star->screen_x + star->screen_y*screeninfo.xres] =
		255 - star->z/24;
	/* and move star closer */
	star->z -= 24;
}

void create_star(struct star* star)
{
	static unsigned int num = 0;
	star->x = rndtable[num%NUMRND]*16;
	star->y = rndtable[(num + NUMRND/2)%NUMRND]*16;
	star->z = ZMAX;
	num++;
}

void init_starfield(char *screenbuf, char *pal, int xres, int yres)
{
	screeninfo.screen = screenbuf;
	screeninfo.xres   = xres;
	screeninfo.yres   = yres;

	for(unsigned int i = 0; i < xres*yres; i++) {
		screenbuf[i] = 0;
	}

	set_pal(pal);
	for(int i = 0; i < MAXSTARS; i++) {
		/* create new stars */
		create_star(&stars[i]);
		/* but randomize the Z too (0-4096)*/
		stars[i].z = (rndtable[i%NUMRND]+127)*(ZMAX/256);
	}
}

void calc_starfield()
{
	for(int i = 0; i < MAXSTARS; i++) {
//		delete_star(&stars[i]);
		update_star(&stars[i]);
	}
}
