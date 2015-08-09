#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <pthread.h>
#include <semaphore.h>
#include "starfield.h"
#include "fader.h"

#define NR_THREADS	4

static int running = 1;

static char *fbp = 0;
static struct fb_var_screeninfo var;
static sem_t sem[NR_THREADS];
static sem_t sem_main[NR_THREADS];

void exit_prog(int sig)
{
	printf("cought signal %d\n",sig);
	running = 0;
}

static void *fade_worker(void *arg)
{
	int id = *((int *)arg);
	while (running) {
		sem_post(&sem_main[id]);
		sem_wait(&sem[id]);
		fade(fbp + id*var.xres*(var.yres/NR_THREADS-1), var.xres,
		     var.yres/NR_THREADS +
		     (id == NR_THREADS-1 ? NR_THREADS/2 : 1));
	}
	sem_post(&sem_main[id]);

	return 0;
}

int main()
{
	struct fb_fix_screeninfo fix;
	unsigned short           red[256];
	unsigned short           green[256];
	unsigned short           blue[256];
	struct fb_cmap           cmap = { 0, 256, red, green, blue, NULL };
	unsigned short           ored[256];
	unsigned short           ogreen[256];
	unsigned short           oblue[256];
	struct fb_cmap           ocmap = { 0, 256, ored, ogreen, oblue, NULL };
	int screensize;
	int fbfd = open("/dev/fb0", O_RDWR);
	char tmppal[768];
	int i;

	int id[NR_THREADS];
	pthread_t thread_id[NR_THREADS];

	if (!fbfd) {
		printf("error, can't open frame buffer\n");
		return 1;
	}

	if (ioctl(fbfd, FBIOGET_FSCREENINFO, &fix)) {
		printf("error reading fix\n");
		return 2;
	}

	if (ioctl(fbfd, FBIOGET_VSCREENINFO, &var)) {
		printf("error reading var\n");
		return 3;
	}

	printf("xres = %u, yres = %u\n", var.xres, var.yres);
	screensize = var.xres * var.yres * var.bits_per_pixel/8;
	fbp = (char*)mmap(0, screensize, PROT_READ |
			  PROT_WRITE, MAP_SHARED, fbfd, 0);
	if ((int)fbp == -1) {
		printf("error map\n");
		return 4;
	}

	init_starfield(fbp, tmppal, var.xres, var.yres);

	/* update framebuffer palette */
	if (ioctl(fbfd, FBIOGETCMAP, &ocmap)) {
		printf("error getting pal\n");
		return 5;
	}

	for (i = 0; i < 256; i++) {
		cmap.red[i]   = ((unsigned short)tmppal[i*3]) << 8;
		cmap.green[i] = ((unsigned short)tmppal[i*3 + 1]) << 8;
		cmap.blue[i]  = ((unsigned short)tmppal[i*3 + 2]) << 8;
	}

	if (ioctl(fbfd, FBIOPUTCMAP, &cmap)) {
		printf("error setting pal\n");
		return 6;
	}

	(void) signal(SIGINT, exit_prog);

	printf("Number of threads: %d\n", NR_THREADS);

	for (i = 0; i < NR_THREADS; i++) {
		sem_init(&sem[i], 0, 0);
		sem_init(&sem_main[i], 0, 0);
		id[i] = i;
		pthread_create(&thread_id[i], 0, fade_worker, &id[i]);
	}

	int j = 0;
	while (running) {
		calc_starfield();
		if (j++ < 4)
			continue;
		j = 0;

		for (i = 0; i < NR_THREADS; i++) {
			sem_wait(&sem_main[i]);
			sem_post(&sem[i]);
		}
	}

	for (i = 0; i < NR_THREADS; i++) {
		sem_post(&sem[i]);
		pthread_join(thread_id[i], 0);
	}

	ioctl(fbfd, FBIOPUTCMAP, &ocmap);
	munmap(fbp, screensize);
	close(fbfd);
	printf("done\n");
	(void) signal(SIGINT, SIG_DFL);

	return 0;
}
