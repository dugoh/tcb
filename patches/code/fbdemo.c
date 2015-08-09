    #include <stdio.h>  
    #include <stdlib.h>
    #include<string.h>
    #include <errno.h>
    #include <fcntl.h>  
    #include <sys/mman.h>  
    #include <linux/fb.h>
    #include <unistd.h>  
    #include <sys/ioctl.h>

unsigned int* Init()
{
	int fd;
	struct fb_fix_screeninfo finfo;  
        struct fb_var_screeninfo vinfo;  
	unsigned int *fbmem=NULL;
      
        fd = open("/dev/fb0", O_RDWR);
        if (!(fd)) 
	{  
            printf("Cannot open framebuffer device.\n");  
		printf("%s\n", strerror(errno));
            exit(1);
        }  
        printf("The framebuffer device was opened successfully.\n");  
      
        if (ioctl(fd, FBIOGET_FSCREENINFO, &finfo)) 
	{  
            printf("Error reading fixed information.\n");
		printf("%s\n", strerror(errno));
		close(fd);
		exit(1);
        } else
	{
        printf("fix info - card id       :%s\n", finfo.id);  
        printf("fix info - smem start    :0x%x\n", finfo.smem_start);  
        printf("fix info - smem len      :0x%x\n", finfo.smem_len);  
        printf("fix info - type          :%d\n", finfo.type);  
        printf("fix info - visual        :%d\n", finfo.visual);  
        printf("fix info - line length   :%d\n\n", finfo.line_length);  
	}     
 
        if (ioctl(fd, FBIOGET_VSCREENINFO, &vinfo)) 
	{  	
            printf("Error reading variable information.\n");  
		printf("%s\n", strerror(errno));
		close(fd);
            exit(1);  
        }  else
	{
        printf("var info - xres          :%d\n", vinfo.xres);  
        printf("var info - yres          :%d\n", vinfo.yres);  
        printf("var info - xres virtual  :%d\n", vinfo.xres_virtual);  
        printf("var info - yres virtual  :%d\n", vinfo.yres_virtual);  
        printf("var info - x offset      :%d\n", vinfo.xoffset);  
        printf("var info - y offset      :%d\n", vinfo.yoffset);  
        printf("var info - bits_per_pixel:%d\n", vinfo.bits_per_pixel);  
        printf("var info - width         :%d\n", vinfo.width);  
        printf("var info - height        :%d\n", vinfo.height);
	}

        fbmem = mmap ( NULL, 640*400*2, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0 );
        if (fbmem == NULL)
        {
            printf("Error executing mmap.\n");
            printf("%s\n", strerror(errno));
            close(fd);
            exit(1);
        }
	return fbmem;
}    
      
    int main(int argc, char *argv[])  
    {  
	int i,j;
	unsigned int *fbmem = NULL;	

	fbmem = Init();

	unsigned int color=0x0;
	while(1)
	{	
		unsigned int *fbp = fbmem;
		for(j=0; j<400; j++)
		for(i=0; i<640; i+=2)
		{
			int r = ( ( ((i+color)^(j+color)) + (color>>2)) >>3)&0x1F;
			int g = (((i-color)&(j+color))>>2)&0x3F;
			int b = ( ( ((i-color)^~(j-color)) + (color >> 2)) >>3)&0x1F;
			*fbp = r | (g<<5) | (b<<11) | ((r | (g<<5) | (b<<11))<<16);
			fbp++;
		}
		color++;
	}
        return 0;
    }

