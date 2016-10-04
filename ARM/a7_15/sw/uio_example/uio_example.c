#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <poll.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <string.h>
#include <time.h>


#define SM_BASE       0x10000000
#define SM_REG_SIZE   0x1000


typedef struct {
	unsigned ADR;
	unsigned CTL;
}volatile sm_reg_t;

sm_reg_t *sm_reg;

int smDevice;

void enableInterrupt(int fd) {
	uint32_t info = 1; /* unmask */
	ssize_t nb = write(fd, &info, sizeof(info));
	if (nb < sizeof(info)) {
		perror("write");
		close(fd);
		exit(EXIT_FAILURE);
	}
}

int waitForInterrupt(int fd) {
	struct pollfd fds = { .fd = fd, .events = POLLIN, };

	uint32_t info;
	ssize_t nb;

	int ret = poll(&fds, 1, -1);
	if (ret <= 0) {
		perror("poll()");
		close(fd);
		exit(EXIT_FAILURE);
	}

	nb = read(fd, &info, sizeof(info));
	if (nb == sizeof(info)) {
		return info;
	}

	printf("Interrupt read returned wrong size #%u!\n", info);
	return 0;
}

int executeSM(void) {
	printf("Enabling Interrupt\n");
	enableInterrupt(smDevice);

	printf("Programming Registers\n");
	sm_reg->ADR = 0x12345678;
	sm_reg->CTL = 0x1;

	printf("Waiting For Interrupt\n");
	if (waitForInterrupt(smDevice)) {
		printf("Resetting CTL Register\n");
		sm_reg->CTL = 0;
	}
}

int main(void) {
	printf("Opening SM /dev/uio0\n");
	smDevice = open("/dev/uio0", O_RDWR);
	if (smDevice < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}

	/* mmap the UIO devices */
	sm_reg = (sm_reg_t *) mmap(NULL, SM_REG_SIZE, PROT_READ | PROT_WRITE,
			MAP_SHARED, smDevice, 0);
	if (!sm_reg) {
		printf("mmapn sm_reg failed");
		return -1;
	}

	executeSM();

	close(smDevice);

	exit(EXIT_SUCCESS);
}

