#include <ctime>
#include <iostream>
#include <complex>
#include <vector>
#include <omp.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/ioctl.h> 
#include <fcntl.h>
#include <linux/fb.h>
#include <unistd.h>

// or1k-linux-musl-g++ -fopenmp -O2 -mhard-float mandelpar.c -lgomp -o mandelpar
 
typedef std::complex<float> complex;

static short int *fbp = 0;

class Color
{
    public:
    float r, g, b;
    Color() {r=0.; g=0.; b=0.;}
    Color(float _r, float _g, float _b) : r(_r),b(_b),g(_b)
    {}
};

 
int compute(complex c, int maxIterations)
{
  int count = 0;
  complex z; 
 
  while (abs(z) <= 2.0 && count < maxIterations) 
  {
    z = z * z + c;
    ++count;
  }
  return count;
}
 

inline Color color(int height, int max)
{
  // color scheme from: 
  // http://shreyassiravara.wordpress.com/2010/08/14/the-mandelbrot-set/
  if (height >= max) return Color(0., 0., 0.);
  float h = log(float(height)) / log(float(max));
  return Color(0.9 * h, 0.8 * h, 0.6 * h);
}
 
inline float scale(int pos, int length, float low, float high)
{
  return low + pos * (high-low) / (length-1);
}
 

void mandelbrot(int width, int height, 
                 int maxIterations,
                 complex left_bottom, complex right_top)
{
 
  #pragma omp parallel for schedule(guided)
  for (int y = 0; y < height; ++y)
  {
     int tid = omp_get_thread_num();
     printf("calculate line %i with thread %i\n", y, tid);
     for (int x = 0; x < width; ++x)
     {
      complex c(scale(x, width,  real(left_bottom), real(right_top)),
                scale(y, height, imag(left_bottom), imag(right_top)));
 
      Color col = color(compute(c, maxIterations), maxIterations);
      fbp[y*width+x] = ((int)(col.r*0x1F)) | (((int)(col.g*0x3F))<<5) | (((int)(col.b*0x1F))<<11);
    }	
  }
}
 
int main()
{
  int maxIterations = 100;
  complex left_bottom(-2.0, -2.0);
  complex right_top  ( 2.0,  2.0);
  struct fb_var_screeninfo var;
  struct fb_fix_screeninfo fix;

  int fbfd = open("/dev/fb0", O_RDWR);
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

  int nthreads = omp_get_num_threads();
  printf("Using %i cores\n", nthreads);

  int screensize = var.xres * var.yres * var.bits_per_pixel/8;
  fbp = (short int*)mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fbfd, 0);
  if ((int)fbp == -1) {
    printf("error map\n");
    return 4;
  }

  mandelbrot(var.xres, var.yres, maxIterations, left_bottom, right_top);
  std::cout << clock() / float(CLOCKS_PER_SEC) << " seconds CPU time\n";

  return 0;
}

