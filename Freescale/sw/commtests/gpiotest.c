#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define MAX_BUF 512

void
main(void) {
  int fd;
  char buf[MAX_BUF]; 
  int i;
  int gpio = 0;

  printf("Opening GPIO_0\n");
  fd = open("/sys/class/gpio/export", O_WRONLY);
  sprintf(buf, "%d", gpio); 
  write(fd, buf, strlen(buf));
  close(fd);

  printf("GPIO_0 setting as OUT\n");
  sprintf(buf, "/sys/class/gpio/gpio%d/direction", gpio);
  fd = open(buf, O_WRONLY);
  // Set out direction
  write(fd, "out", 3); 
  close(fd);

  printf("Writing HIGH to GPIO_0\n");
  sprintf(buf, "/sys/class/gpio/gpio%d/value", gpio);
  fd = open(buf, O_WRONLY);
  // Set GPIO high status
  write(fd, "1", 1); 
  printf("Pausing 1 second\n");
  sleep(1);
  printf("Writing LOW to GPIO_0\n");
  // Set GPIO low status 
  write(fd, "0", 1); 
  printf("Pausing 1 second\n");
  sleep(1);
  printf("Writing HIGH to GPIO_0\n");
  // Set GPIO high status
  write(fd, "1", 1); 
  printf("Pausing 1 second\n");
  sleep(1);
  printf("Writing LOW to GPIO_0\n");
  // Set GPIO low status 
  write(fd, "0", 1); 
  close(fd);
  printf("Pausing 1 second\n");
  sleep(1);

  printf("Closing GPIO_0\n");
  fd = open("/sys/class/gpio/unexport", O_WRONLY);
  sprintf(buf, "%d", gpio);
  write(fd, buf, strlen(buf));
  close(fd);

  gpio = 1;

  printf("Opening GPIO_1\n");
  fd = open("/sys/class/gpio/export", O_WRONLY);
  sprintf(buf, "%d", gpio); 
  write(fd, buf, strlen(buf));
  close(fd);

  printf("GPIO_1 setting as IN\n");
  sprintf(buf, "/sys/class/gpio/gpio%d/direction", gpio);
  fd = open(buf, O_WRONLY);
  // Set out direction
  write(fd, "in", 3); 
  close(fd);

  sprintf(buf, "/sys/class/gpio/gpio%d/value", gpio);
  fd = open(buf, O_RDONLY);
  char value; 
  for(i = 1; i < 6; i++) {
    lseek(fd, 0, SEEK_SET);
    read(fd, &value, 1);
    printf("[%d/5] Reading GPIO_1, value is %c\n", i, value);
    sleep(1);
  }
  close(fd);

  printf("Closing GPIO_1\n");
  fd = open("/sys/class/gpio/unexport", O_WRONLY);
  sprintf(buf, "%d", gpio);
  write(fd, buf, strlen(buf));
  close(fd);
}

