#include <stdint.h>

void fade(unsigned char* ptr, int width, int height)
{
	uint32_t av,offset=width;

	for (int y = 1; y < height-1; y++) {
		offset++; /* skip first x pixel */
		for (int x = 1; x < width-1; x++) {
			av =	(uint32_t)ptr[offset-1] +	/* left */
				(uint32_t)ptr[offset+1] +	/* right */
				(uint32_t)ptr[offset-width] +	/* above */
				(uint32_t)ptr[offset+width];	/* below */
			av /= 4;
			if (av > 0) av -= 1;
			ptr[offset] = (unsigned char)av;
			offset++;
		}
		offset++; /* skip last x pixel */
	}
}
