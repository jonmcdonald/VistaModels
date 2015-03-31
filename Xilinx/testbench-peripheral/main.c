#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

FILE *procFile = 0;

void readProc() {
  char * line = NULL;
  size_t len = 0;
  ssize_t read;
  while ((read = getline(&line, &len, procFile)) != -1) {
    printf("%s", line);
  }
}

void writeProc(int led) {
  printf("\rSending code %d%d%d%d", (led & 0b1000) >> 3, (led & 0b0100) >> 2, (led & 0b0010) >> 1, led & 0b0001);
  fflush(stdout);
  fprintf(procFile, "%d%d%d%d\n", (led & 0b1000) >> 3, (led & 0b0100) >> 2, (led & 0b0010) >> 1, led & 0b0001);
  fflush(procFile);
}

int startTest() {
  int i, j;

  printf("1. Reading from /proc/peripheral\n");
  usleep(2000000);
  readProc();

  printf("\n");
  printf("2. Writing to /proc/peripheral\n");
  usleep(2000000); 

  for(i = 0; i < 5; i++) {
    for(j = 0; j < 16; j++) {
      writeProc(j);
      usleep(500000); 
    }
  }

  printf("\n");
}

int main(int argc, char *argv[])
{
  printf("Testing the custom peripheral\n\n");

  procFile = fopen("/proc/peripheral", "r+");
  if (procFile == 0) {
    fprintf(stderr, "Can't open /proc/peripheral\n");
    exit(1);
  }

  startTest();
  fclose(procFile);

  printf("\nFinished Testing the custom peripheral\n");
  return 0;
}
