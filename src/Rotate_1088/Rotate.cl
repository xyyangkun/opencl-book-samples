#pragma OPENCL EXTENSION cl_amd_printf : enable
__kernel void rotate_y(
					    const int w1,
						const int h1,
						__global unsigned char *src,
						__global unsigned char *dst
						)
{
    int h = get_global_id(0);
    int w = get_global_id(1);
	//printf("w=%d, h=%d\n", w, h);
	//printf("%d == %d\n", (h+y)*w1 + x + w, h*w2 + w);

	// 这个是复制
	// dst[w1*h + w] = src [w1*h+w];

	// 镜像
	//dst[w*h1 + h] = src [w1*(h1 - h)+w];

	//  90度
	//dst[(w1-w)*h1 + h] = src [w1*h+w];

	// 270
	//dst[(w1-w)*h1 + h - 1080] = src [w1*h+w];
	dst[(w1-w-1)*h1 + h] = src [w1*h+w];
#if 0
	if(w>1917)
	{
		printf("w=%d h=%d w1=%d h1=%d, (w1-w-1)*h1 + h=%d  w1*h+w=%d\n",
			   w, h, w1, h1, (w1-w-1)*h1 + h, w1*h+w);
	}
#endif
}

// 这个和 cpu 上实现不同的地方是注意width, height,
// opencl 中参数是 width/2  height/2
__kernel void rotate_uv(
					    const int width,
						const int height,
						__global unsigned char *src,
						__global unsigned char *dst
						)
{
    int h = get_global_id(0);
    int w = get_global_id(1);

	// 复制颜色 
	//dst[w1 * h + 2 * w    ] = src [w1 * h + 2 * w];
	//dst[w1 * h + 2 * w + 1] = src [w1 * h + 2 * w + 1];

	// 镜像
	//dst[2073600 + w * height*2 + 2 * h    ] = src [2073600 + width*2 * (height - h) + 2 * w];
	//dst[2073600 + w * height*2 + 2 * h + 1] = src [2073600 + width*2 * (height - h) + 2 * w + 1];

	// 270
	//dst[2073600 + (width-w) * height*2 + 2 * h    -1080] = src [2088960 + width*h*2 + 2 * w];
	//dst[2073600 + (width-w) * height*2 + 2 * h + 1-1080] = src [2088960 + width*h*2 + 2 * w + 1];
	dst[2073600 + (width-w-1) * height*2 + 2 * h    ] = src [2088960 + width*h*2 + 2 * w];
	dst[2073600 + (width-w-1) * height*2 + 2 * h + 1] = src [2088960 + width*h*2 + 2 * w + 1];

#if 0
	if(w>957)
	{
		printf("w=%d h=%d width=%d height=%d,  (width-w) * height*2 + 2 * h= %d width*h*2 + 2 * w=%d\n",
			   w, h, width, height,
			   (width-w-1) * height*2 + 2 * h, width*h*2 + 2 * w);
	}
#endif

	// 90度
	//dst[2073600 + (w1 - w) * h1 + 2 * h    ] = src [2073600 + w1 * h + 2 * w];
	//dst[2073600 + (w1 - w) * h1 + 2 * h + 1] = src [2073600 + w1 * h + 2 * w + 1];
	//printf("%d %d %d %d==>%d %d\n", w, h, width, height, (w * height*2 + 2 * h), (width*2 * (height - h) + 2 * w));
}


