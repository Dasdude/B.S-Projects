#include <stdint.h>
#include <iostream>
#include <fstream>
#include <map>
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
#include <ostream>
#include <sstream>

#define BUFFER_SIZE 2
#define BACKLOG_PLAYERSNO 2
#define SERVERPORT "3550"
#define IP "hello"

using namespace std;
char map[10][10];
char map1Dimension[100];
int mapRowNo;
int mapColNo;
int PlayerRedPosition[2];
int PlayerBluePosition[2];
int PlayerRedScore;
int PlayerBlueScore;
int socketID;
int socket1,socket2;
char* socket1color;
char* socket2color;
bool Gameover=false;
char socket2colorCharacter,socket1colorCharacter;
pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
void setMapCellValue(int row,int col,char value)
{
	map1Dimension[(row*mapColNo)+col]=value;
}
char getMapCellValue(int row,int col)
{
	return map1Dimension[(row*mapColNo)+col];
}
char* recieveMessage(int socketID)
{
		char bufferRecieveMessage[BUFFER_SIZE]={0};
		recv(socketID,bufferRecieveMessage,BUFFER_SIZE,0);
		printf("\n Recieved Message :  \n %s \n",bufferRecieveMessage);
		return bufferRecieveMessage;
}
int sendMessage(int socketID,char* message)
{

	int lenghtSent;
	lenghtSent=send(socketID,message,strlen(message),0);
	if(lenghtSent==-1)
	{
		printf("The specified message was not sent :\n %s \n",message);
		perror("sending Error: \n");
	}
	return lenghtSent;
}
int acceptSocket(int socket,struct sockaddr* player,socklen_t* socketAddressSize)
{
	int newSocket;
	newSocket=accept(socket,player,socketAddressSize);
	if(newSocket==-1)
	{
		printf("Socket info : %s \n",player->sa_data);
		perror("Socket accept Problem: \n");

	}
	else
	{
		printf("connection Established socketID:%d \n",newSocket);
	}
	return newSocket;
}
struct playerinfo
{
	int socket;
	char color;
};
int CellScore(int row,int col)//ZeroBase
{
	switch (getMapCellValue(row,col)) {
		case 'G':
			Gameover=true;
			return 100;
			break;
		case 'C':
			return 10;
			break;
		case 'E':
			return 0;
		default:
			break;
	}
}
int MapReader(char* fileName)
{
   ifstream indata; // indata is like cin
   indata.open(fileName); // opens the file
   if(!indata) { // file couldn't be opened
      cerr << "Error: file could not be opened" << endl;
      exit(1);
   }
   indata >>mapRowNo;
   indata >>mapColNo;
   int i=0;
   while ( !indata.eof() )
   {
      indata >> map1Dimension[i];
      switch (map1Dimension[i]) {
		case 'R':
			PlayerRedPosition[0]=(int)(i/mapColNo);
			PlayerRedPosition[1]=i%mapColNo;
			break;
		case 'B':
			PlayerBluePosition[0]=(int)(i/mapColNo);
			PlayerBluePosition[1]=i%mapColNo;
			break;
		default:
			break;
	}
      i++;
   }
   map1Dimension[i]='\0';
   indata.close();
   cout << "End-of-file reached.." << endl;
   return 0;
}
bool movePlayer(char color,char movementChar)
{
	int selectedPlayerPosition[2];
	int destinationPosition[2];
	bool Red0blue1;
	if(color=='r')
	{
		selectedPlayerPosition[0]=PlayerRedPosition[0];
		selectedPlayerPosition[1]=PlayerRedPosition[1];
		Red0blue1=false;
	}
	else{

		if(color='b')
		{
		selectedPlayerPosition[0]=PlayerBluePosition[0];
		selectedPlayerPosition[1]=PlayerBluePosition[1];
		Red0blue1=true;
		}
		else
			return false;
	}
	switch (movementChar) {
		case 'w':

			destinationPosition[0]=selectedPlayerPosition[0]-1;
			destinationPosition[1]=selectedPlayerPosition[1];
			break;
		case 's':
			destinationPosition[0]=selectedPlayerPosition[0]+1;
			destinationPosition[1]=selectedPlayerPosition[1];
			break;
		case 'a':
			destinationPosition[0]=selectedPlayerPosition[0];
			destinationPosition[1]=selectedPlayerPosition[1]-1;
			break;
		case 'd':
			destinationPosition[0]=selectedPlayerPosition[0];
			destinationPosition[1]=selectedPlayerPosition[1]+1;
			break;


		default:
			return false;
			break;
	}
	printf("Selected Player Position : %d , %d \n",selectedPlayerPosition[0],selectedPlayerPosition[1]);
	printf("destination = %d * %d",destinationPosition[0],destinationPosition[1]);
	if((destinationPosition[0]<0) ||((destinationPosition[0])>=mapRowNo)||(destinationPosition[1]<0)||(destinationPosition[1]>=mapColNo))
		{
		printf("map Spec : %d ,%d ",mapColNo,mapRowNo);
		printf("Wrong MOvement \n");
		return false;
		}
	if( (destinationPosition[0]==PlayerRedPosition[0]&&destinationPosition[1]==PlayerRedPosition[1])||(destinationPosition[0]==PlayerBluePosition[0]&&destinationPosition[1]==PlayerBluePosition[1]))
		{
		printf("Wrong MOvement2 \n");
		return false;
		}
	else
	{
		printf("Good Movement \n");
		if(color=='r')
			PlayerRedScore+=CellScore(destinationPosition[0],destinationPosition[1]);

		else
			PlayerBlueScore+=CellScore(destinationPosition[0],destinationPosition[1]);

		setMapCellValue(destinationPosition[0],destinationPosition[1],(getMapCellValue(selectedPlayerPosition[0],selectedPlayerPosition[1])));
		setMapCellValue(selectedPlayerPosition[0],selectedPlayerPosition[1],'E');
		if(Red0blue1)
			{
			PlayerBluePosition[0]=destinationPosition[0];
			PlayerBluePosition[1]=destinationPosition[1];
			}
		else
		{
			PlayerRedPosition[0]=destinationPosition[0];
			PlayerRedPosition[1]=destinationPosition[1];
		}
		return true;
	}

}
void* PlayerThreadListener(void* playerinf)
{
		struct playerinfo player=*((playerinfo*)playerinf);
		char* recievedMessage= new char[BUFFER_SIZE];

		while(true)
		{
			recievedMessage = recieveMessage(player.socket);
			if('a'<=recievedMessage[0]&&recievedMessage[0]<='w')
			{
				pthread_mutex_lock(&mutex1);

				movePlayer(player.color,recievedMessage[0]);
				if(Gameover)
					sendMessage(player.socket,"you Have Won");
				pthread_mutex_unlock(&mutex1);
			}
		}
}
void sendMapAndScoreFunction(int socket,char a)
{
	string sendingString;
	ostringstream oss;
			char* be=new char[100];
	switch (a) {
		case 'r':
			oss <<PlayerRedScore;
			sendingString = oss.str();
			sendingString.append(map1Dimension);
//			sendingString.insert(sendingString.size(),1,'\0');
			sendingString.copy(be,sendingString.size(),0);
			be[sendingString.size()]='\0';
			sendMessage(socket,be);
			break;
		case 'b':
			oss <<PlayerBlueScore;
			sendingString = oss.str();
			sendingString.append(map1Dimension);
			sendingString.copy(be,sendingString.size(),0);
			be[sendingString.size()]='\0';
			sendMessage(socket,be);
			break;
		default:
			printf("sendMapAndScoreFunction no color a= %c \n",a);
			break;
	}
}
void* mapSendThread(void* a)
{
	while(true)
	{
		pthread_mutex_lock(&mutex1);
		sendMapAndScoreFunction(socket1,socket1colorCharacter);
		sendMapAndScoreFunction(socket2,socket2colorCharacter);
		pthread_mutex_unlock(&mutex1);
		usleep(6000000);
	}
}


int main(int argc, char **argv) {
		char* port=SERVERPORT;
		int socketAddressSize;
		bool redOcuptn;
		bool blueOcuptn;
		int socketTest;
		struct playerinfo player1info , player2info;
		struct addrinfo myaddress,*result;
		struct addrinfo player1;
		struct sockaddr_in player2;
		pthread_t player1Thread,player2Thread;
		pthread_t mapSenderThread;
		int player1RecieverThreadID,player2RecieverThreadID;
		int mapSenderThreadID,
		socketID = socket(AF_INET, SOCK_STREAM, 0);
		if(socketID==-1)
			{
				printf("socket error1 \n");
			}
		socketTest = socket(AF_INET, SOCK_STREAM, 0);
		printf("socketTestID = %d \n ",socketTest);
		memset(&myaddress,0,sizeof(myaddress));
		myaddress.ai_family=AF_UNSPEC;
		myaddress.ai_flags= AI_PASSIVE;
		myaddress.ai_socktype=SOCK_STREAM;
		getaddrinfo(NULL,port,&myaddress,&result);
		if(bind(socketTest,result->ai_addr,result->ai_addrlen)==-1)
		{
				printf("binding error1 \n");
				return 0;
		}
		if(listen(socketTest,BACKLOG_PLAYERSNO)!=0)
			printf("listen error1 \n");
		socketAddressSize=sizeof(sockaddr_in);
		socket1 = acceptSocket(socketTest,(struct sockaddr*)&player1,(socklen_t*)&socketAddressSize);
		socket2 = acceptSocket(socketTest,(struct sockaddr*)&player2,(socklen_t*)&socketAddressSize);

			MapReader("map.txt");
			//To this point socket Established for Both players
			sendMessage(socket1,"45");//TODO
			sendMessage(socket2,"45");//TODO
			socket2color=recieveMessage(socket2);
			socket2colorCharacter=socket2color[0];
			socket1color=recieveMessage(socket1);
			socket1colorCharacter=socket1color[0];
			player1info.color=socket1color[0];
			player2info.color=socket2colorCharacter;
			player1info.socket=socket1;
			player2info.socket=socket2;
			player1RecieverThreadID=pthread_create(&player1Thread,NULL,PlayerThreadListener,(void*)&player1info);
			player2RecieverThreadID=pthread_create(&player2Thread,NULL,PlayerThreadListener,(void*)&player2info);
			mapSenderThreadID=pthread_create(&mapSenderThread,NULL,mapSendThread,NULL);

			while(true)
			{

			}

}

/*
 * Server.cpp
 *
 *  Created on: Mar 3, 2012
 *      Author: Ehsan
 */




