#pragma once
#include <fstream>
#include <vector>
#include <iostream>

using namespace std;

enum format {
	RGB,
	RGBA
};

struct Image {
	vector<unsigned char> data;
	int width;
	int height;
	enum format format;
};

class BMPLoader
{
public:
	static Image load(const char* path) {
		ifstream file(path, ios::in | ios::binary);
		char* signature = new char[2];
		char* i = new char[4];
		char* s = new char[2];
		int start;
		int file_size;
		int inf_size;
		int width;
		int height;
		short bit_depth;
		int compression;
		int bit_map_size;
		int palett_colors;
		int used_colors;
		Image result;


		file.read(signature, 2);
		file.read((char*)& file_size, 4);

		//additional information
		file.read(i, 4);

		file.read((char*)& start, 4);

		file.read((char*)& inf_size, 4);
		file.read((char*)& width, 4);
		file.read((char*)& height, 4);

		//Skip next 2 bytes
		file.read(s, 2);

		file.read((char*)& bit_depth, 2);

		file.read((char*)& compression, 4);

		file.read((char*)& bit_map_size, 4);

		//skip next 8 bytes
		file.read(i, 4);
		file.read(i, 4);

		file.read((char*)& palett_colors, 4);
		file.read((char*)& used_colors, 4);

		int rowSize = ((bit_depth * width) / (float)32) * 4;
		int pixel_array_size = rowSize * height;
		vector<unsigned char> pixels;
		if (bit_depth == 24) pixels.resize(pixel_array_size * 3);
		if (bit_depth == 32) pixels.resize(pixel_array_size * 4);
		int z = 0;
		for (int j = 0; j < height; j++) {
			int p = 0;
			for (int i = 0; i < rowSize; i += 3) {
				if (bit_depth == 24) {
					result.format = RGB;
					unsigned char* pixel = new unsigned char[3];
					file.read((char*)pixel, 3);
					p += 3;
					pixels[z++] = pixel[2];
					pixels[z++] = pixel[1];
					pixels[z++] = pixel[0];
				}
				if (bit_depth == 32) {
					result.format = RGBA;

					unsigned char* pixel = new unsigned char[4];
					file.read((char*)pixel, 4);
					p += 4;
					pixels[z++] = pixel[2];
					pixels[z++] = pixel[1];
					pixels[z++] = pixel[0];
					pixels[z++] = pixel[3];

				}

			}
			while (p % 4 != 0) {
				p++;
				file.read(new char(), 1);
			}
		}
		result.data = pixels;
		result.width = width;
		result.height = height;

		file.close();



		return result;
	}
};

