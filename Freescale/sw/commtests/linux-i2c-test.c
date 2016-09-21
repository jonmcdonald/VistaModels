#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define CMD_RESET 0x0
#define CMD_REQUEST_SIZE 0x1
#define CMD_REQUEST_DATA 0x2


void sendCommand(int i2cfile, unsigned char cmd) {
	unsigned char buf[1];
	buf[0] = cmd;
	if (write(i2cfile,buf,1) != 1) {
		printf("Failed to send command to the i2c bus.\n");
		exit(1);
	}
}

unsigned int receiveSize(int i2cfile) {
	unsigned int size;
	unsigned char bytes[10];
	if (read(i2cfile,&bytes,4) != 4) {
		printf("Failed to read size\n");
		exit(1);
	}

	size = bytes[3] + ((unsigned int)bytes[2] << 8)
        		+ ((unsigned int)bytes[1] << 16) + ((unsigned int)bytes[0] << 24);

	return size;
}

void receiveData(int i2cfile, unsigned char* buf, unsigned int size) {
	unsigned char bytes[10];
	if (read(i2cfile,buf,size) != size) {
		printf("Failed to read data\n");
		exit(1);
	}
}

void
main(void) {
	int i2cfile;
	FILE* outfile;
	char filename[40];
	int addr = 0x4;        // The I2C address
	int i;

	printf("Opening /dev/i2c-0\n");
	sprintf(filename,"/dev/i2c-0");
	if ((i2cfile = open(filename,O_RDWR)) < 0) {
		printf("Failed to open the bus.");
		exit(1);
	}

	printf("Using device at address 0x4\n");
	if (ioctl(i2cfile,I2C_SLAVE,addr) < 0) {
		printf("Failed to acquire bus access and/or talk to slave.\n");
		exit(1);
	}

	char buf[10] = {0};
	unsigned int data;

	printf("Resetting peripheral\n");
	sendCommand(i2cfile, CMD_RESET);
	printf("Requesting size of data\n");
	sendCommand(i2cfile, CMD_REQUEST_SIZE);
	printf("Receiving size of data\n");
	unsigned int size = receiveSize(i2cfile);
	printf("   size of data = %d\n", size);

	printf("Requesting data\n");
	sendCommand(i2cfile, CMD_REQUEST_DATA);

	char *buffer = malloc(size+2);
	printf("Receiving data\n");
	receiveData(i2cfile, buffer, size);

	close(i2cfile);

	sprintf(filename,"output.txt");
	outfile=fopen(filename, "w");
	printf("Creating output.txt file.\n");
	fwrite(buffer,1, size, outfile);
	fclose(outfile);
}
