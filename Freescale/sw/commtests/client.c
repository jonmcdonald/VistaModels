/****************** CLIENT CODE ****************/

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

void error(char *msg) {
  fprintf(stderr, "%s\n", msg);
  exit(-1);
}

int main(int argc, char **argv){
  int clientSocket;
  char buffer[1024];
  struct sockaddr_in serverAddr;
  socklen_t addr_size;
  int portno = 8888;
  char defaultip[] = "127.0.0.1";
  char *ipaddr = defaultip;
  char message[128] = "Hello from the client.\n";

  if (argc == 2) {
    strcpy(message, argv[1]);
    strcpy(message+strlen(message), "\n");
  } else if (argc == 3) {
    strcpy(message, argv[1]);
    strcpy(message+strlen(message), "\n");
    portno = atoi(argv[2]);
  } else if (argc == 4) {
    strcpy(message, argv[1]);
    strcpy(message+strlen(message), "\n");
    portno = atoi(argv[2]);
    ipaddr = argv[3];
  } else if (argc != 1) {
    fprintf(stderr, "usage: %s [<port> [<ip-address>]]\n", argv[0]);
  }

  /*---- Create the socket. The three arguments are: ----*/
  /* 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) */
  if ((clientSocket = socket(PF_INET, SOCK_STREAM, 0)) < 0)
    perror("ERROR opening socket");
  
  
  /*---- Configure settings of the server address struct ----*/
  /* Address family = Internet */
  serverAddr.sin_family = AF_INET;
  /* Set port number, using htons function to use proper byte order */
  serverAddr.sin_port = htons((unsigned short)portno);
  /* Set IP address to localhost */
  serverAddr.sin_addr.s_addr = inet_addr(ipaddr);
  /* Set all bits of the padding field to 0 */
  memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);  

  /*---- Connect the socket to the server using the address struct ----*/
  addr_size = sizeof serverAddr;
  if ((connect(clientSocket, (struct sockaddr *) &serverAddr, addr_size)) < 0)
    perror("Connect returned < 0");

  /*---- Read the message from the server into the buffer ----*/
  //if ((recv(clientSocket, buffer, 1024, 0)) <= 0) perror("recv returned <= 0");

  send(clientSocket, message, strlen(message), 0);

  return 0;
}
