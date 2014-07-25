#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_BUF 1024

int main()
{
    int fd;
    char * myfifo = "tmp_fifo_pipe";
    char buf[MAX_BUF];
    int num;

    mkfifo(myfifo, 0666);

    pid_t pID = fork();
    if (pID == 0) {	//child
      execlp("xterm", "xterm", "-e", "./writer", (char *) 0);
    }
    else if (pID < 0) {	// failed to fork
    }
    else {
      /* open, read, and display the message from the FIFO */
      fd = open(myfifo, O_RDONLY);

      while ( (num = read(fd, buf, MAX_BUF)) > 0 ) {
        buf[num] = '\0';
        printf("Received: %s\n", buf);
      }

      close(fd);
    }

    return 0;
}
