#include <stdint.h>
#include <iostream>
#include <fstream>
#include <map>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <cstdlib>
#include <cstring>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/wait.h>
#include <unistd.h>
#include <netinet/in.h>
#include <pty.h>
#include <pthread.h>
#include <sstream>
#include <string>

#define BACKLOG_PLAYERSNO 2
#define PORT 3510
#define HOSTIP "192.168.160.142"
#define HOSTPORT "3550"
#define BUFFER_SIZE 100

using namespace std;
char map[100][100];
int mapRowSize,MapColSize;
char* map1dimension=new char[100];
int sendMessage(int socketID,const char* message)
{
	int lenghtSent;
	lenghtSent=send(socketID,message,strlen(message),0);
	printf("message Sent , lenghtsent: %d \n",lenghtSent);
	if(lenghtSent==-1)
	{
		printf("The specified message was not sent :\n %s \n",message);
		perror("sending Error: \n");
	}

	return lenghtSent;
}
int sendCharMessage(int socketID,char message)
{
	printf("\n .......send char Message Started......... \n");
	int lenghtSent;
	char sendingcharstar[2]="";
	sendingcharstar[0] =message;
	printf("sending this character to server : %s",&sendingcharstar[0]);
	lenghtSent=send(socketID,&sendingcharstar,strlen(sendingcharstar),0);
	printf("message Sent , lenghtsent: %d \n",lenghtSent);
	if(lenghtSent==-1)
	{
		printf("The specified message was not sent :\n %s \n",&message);
		perror("sending Error: \n");
	}

	return lenghtSent;
}
void* SocketListner(void* socketID)
{
	int clientSocketID = (long int)socketID;
	string recieveBufferString;
	stringstream ss;
	char a[BUFFER_SIZE] = "";
	int recievedLenght=0;
	printf("socketListner Activated \n");
	while(true)
	{
		memset(a,0,BUFFER_SIZE);
		printf("Recieve socketID : %d ",(long int )socketID);
		recievedLenght=recv(clientSocketID,(void*)a,(ssize_t)BUFFER_SIZE,0);
		printf("socketListner Recieved \n");
		if(recievedLenght==-1)
			perror("recieve Error:");
		string recieveBuffer=a;
		printf("socket listener recieved a message : %s \n",recieveBuffer.c_str());
		printf("size of message : %d \n",recieveBuffer.length());
		if(true)
		{
			map1dimension=a;

		}

	}
}


int main(int argc, char **argv) {
			string colorBlue0red1 ;
			char recvbuf[BUFFER_SIZE] = "";
			int socketID;
			int ThreadID;
			char keyboardInput;
			pthread_t recieverThread;
			char* port=HOSTPORT;
			char* ip=HOSTIP;
			struct addrinfo myaddress,*result;
			if((socketID = socket(AF_INET, SOCK_STREAM, 0))==-1)
				{
					printf("socket error1 \n");
				}
			memset(&myaddress,0,sizeof(myaddress));
			myaddress.ai_family=AF_UNSPEC;
			myaddress.ai_flags= AI_PASSIVE;
			myaddress.ai_socktype=SOCK_STREAM;
			if(getaddrinfo(ip,port,&myaddress,&result)==-1)
			{
				perror("getaddrinfo error: \n");
			}
			if(connect(socketID,result->ai_addr,result->ai_addrlen)==-1)
				perror("connect Error: \n");

			else
			{
					printf("Connection Established");
					recv(socketID,recvbuf,BUFFER_SIZE,0);
					mapRowSize= recvbuf[0]-'0';
					MapColSize= recvbuf[1]-'0';
					printf("Map rows : %d \n",mapRowSize);//Tester TOBE REMOVED
					printf("Map cols : %d \n",MapColSize);//Tester TOBe REMOVED
					printf("please Choose Your Color! \n r for Red b for Blue \n ");
					cin>>colorBlue0red1;
					printf("my color : %s \n",colorBlue0red1.c_str());//Tester TOBE REMOVED
					sendMessage(socketID,colorBlue0red1.c_str());
					ThreadID=pthread_create(&recieverThread,NULL,SocketListner,(void*)socketID);
					printf("whileTrue Started \n");
					while(true)
					{
							cin>>keyboardInput;
							sendCharMessage(socketID,keyboardInput);
					}


			}
};
