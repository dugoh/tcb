#include<stdio.h>

#include <directfb.h>
#include <direct/util.h>

/* macro for a safe call to DirectFB functions */
#define DFBCHECK(x)                                                    \
     {                                                                    \
          err = x;                                                        \
          if (err != DFB_OK) {                                            \
               fprintf( stderr, "%s <%d>:\n\t", __FILE__, __LINE__ );     \
               DirectFBErrorFatal( #x, err );                             \
          }                                                               \
     }

static IDirectFB               *dfb;
static IDirectFBSurface        *primary;
static IDirectFBImageProvider  *provider;
static IDirectFBSurface *background;


int main(int argc, char *argv[])
{
     DFBResult err;
     DFBSurfaceDescription dsc;
	IDirectFBDisplayLayer      *layer;
	int xres, yres;

//fprintf(stderr, "1\n");
	if (argc == 1)
	{
		printf("%s image.png\n", argv[0]);
		return 1;
	}

	DFBCHECK(DirectFBInit( &argc, &argv ));

     /* create the super interface */
     DFBCHECK(DirectFBCreate( &dfb ));




//	err = dfb->SetCooperativeLevel( dfb, DFSCL_FULLSCREEN );
//     if (err)
//       DirectFBError( "Failed to get exclusive access", err );
//fprintf(stderr, "2\n");

     /* get the primary surface, i.e. the surface of the primary layer we have
        exclusive access to */
     dsc.flags = DSDESC_CAPS;
     dsc.caps = DSCAPS_PRIMARY;
     err = dfb->CreateSurface( dfb, &dsc, &primary );

//fprintf(stderr, "3\n");

DFBCHECK(primary->GetSize( primary, &xres, &yres ));

//fprintf(stderr, "4\n");

DFBCHECK(dfb->CreateImageProvider( dfb, argv[1], &provider ));
//fprintf(stderr, "5\n");

DFBCHECK (provider->GetSurfaceDescription (provider, &dsc));

DFBRectangle rect;
rect.x = 0;
rect.y = 0;
rect.w = dsc.width;
rect.h = dsc.height;

     dsc.flags = DSDESC_WIDTH | DSDESC_HEIGHT;
     dsc.width = xres;
     dsc.height = yres;
     DFBCHECK(dfb->CreateSurface( dfb, &dsc, &background ));
//fprintf(stderr, "6\n");

     DFBCHECK(provider->RenderTo( provider, background, NULL ));
//fprintf(stderr, "7\n");

     provider->Release( provider );
	 primary->Blit( primary, background, NULL, 0, 0 );
//fprintf(stderr, "8\n");

//background->Release( background );
//primary->Release( primary );
//dfb->Release( dfb );

	return 0;
}
