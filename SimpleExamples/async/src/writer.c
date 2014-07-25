/*  writer.c expects one argument which is the name of a named pipe that has already been created
 *  this program will open the pipe for writing, then read from stdin and write all input to the pipe.
 */

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char ** argv)
{
    int fd;
    int r = 0;
    char buf[1024];

    /* Named pipe should already be created and passed in as argument */
    if (argc != 2) {
      printf("Error: writer expects pipe name as argument.\n");
      sleep(3);
      return 0;
    }

    fd = open(argv[1], O_WRONLY);

    /* While we have input and the pipe is still accepting data
     * read from stdin and write to the named pipe */
    while ((r >= 0) && gets(buf)) {
      r = write(fd, buf, strlen(buf));
    }

    close(fd);

    /* remove the FIFO */
    unlink(argv[1]);

    return 0;
}
