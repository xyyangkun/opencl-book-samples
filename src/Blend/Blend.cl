//#pragma OPENCL EXTENSION cl_amd_printf : enable
__kernel void blend_y(
					    const int w1,
						const int h1,
					    const int w2,
						const int h2,
					    const int x,
						const int y,
						__global unsigned char *src1,
						__global const unsigned char *src2
						)
{
    int h = get_global_id(0);
    int w = get_global_id(1);
	//printf("w=%d, h=%d\n", w, h);
	//printf("%d == %d\n", (h+y)*w1 + x + w, h*w2 + w);

	if(( (h+y)*w1 + x + w <= 1920*1080) && (h*w2 + w <= 1280*720 ))
		src1[(h+y)*w1 + x + w] = src2 [ h*w2 + w];
	else 
		printf("error !!!  h=%d y = %d w1=%d  w=%d w2=%d  %d %d\n",
		h, y, w1, w, w2,
		(h+y)*w1 + x + w ,
		h*w2 + w);
}

__kernel void blend_uv(
					    const int w1,
						const int h1,
					    const int w2,
						const int h2,
					    const int x,
						const int y,
						__global unsigned char *src1,
						__global const unsigned char *src2
						)
{
    int h = get_global_id(0);
    int w = get_global_id(1);

	src1[2073600 + (h + y / 2 ) * w1 + x + 2*w    ] = src2 [w2*h2 +  h*w2 + 2*w];
	src1[2073600 + (h + y / 2 ) * w1 + x + 2*w + 1] = src2 [w2*h2 +  h*w2 + 2*w + 1];
}



__kernel void blend(__global const char *a,
						__global const char *b,
						__global char *result)
{
    int gid = get_global_id(0);

    result[gid] = a[gid] + b[gid];
}

__kernel void blend_2dim(__global const char *a,
						__global const char *b,
						__global char *result)
{
    int w = get_global_id(0);
    int h = get_global_id(1);
	printf("w=%d h=%d ==> %d\t%d\t%d=>%d\n", w, h,  a[h*10+w], b[h*10+w],
		   get_global_size(1), get_global_size(0));

    result[h*10 + w] = a[h*10+w] + b[h*10+w];
}
