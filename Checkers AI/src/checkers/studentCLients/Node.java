package checkers.studentCLients;

import java.util.ArrayList;
import java.util.Random;

import javax.sound.midi.ControllerEventListener;

import checkers.Move;
import checkers.studentCLients.Controller;



public class Node {
	
	
	
int[][] thisBoard ;
Node frontiers;
Node parent;
static int color ;//// false black | true white; 
boolean turn;
boolean minMaxStatus ; //min =false max =true;
int[] utility={-1000,1000};// utility range
Move parentMove;
Node bestChild;
ArrayList<Move> validMoves;
int currentUtility;
int cumulativeParentalPoint;
int level;
static int maxlevel;

Node (Move lastMove ,int[][] Board )
{
	this.thisBoard = new int[8][8];
	for(int i = 0 ;i<8;i++)
	{
		for(int j =0 ; j<8;j++)
		{
			this.thisBoard[i][j] = Board[i][j];//Copy parent Current Situation Board
		}
	}
	this.level = 0;
	this.parentMove=lastMove;
	validMoves=Controller.getValidMoves(this.thisBoard, this.parentMove);
	minMaxStatus = true;
	if(parentMove!=null)
	{
	 Controller.updateTable(thisBoard, parentMove);
	}
	
	this.childGenerator(true);
	
}
 Node(Node parent,Move parentMove,int level){
	
	 this.thisBoard = new int[8][8];
	for(int i = 0 ;i<8;i++)
	{
		for(int j =0 ; j<8;j++)
		{
			this.thisBoard[i][j] = parent.thisBoard[i][j];//Copy parent Current Situation Board
		}
	}
	this.level = level;
	this.parent=parent;
	this.parentMove=parentMove;
	validMoves=Controller.getValidMoves(this.thisBoard, this.parentMove);
	minMaxStatus = checkThisNodeMinMax();
	Controller.updateTable(thisBoard, parentMove);
	this.childGenerator(false);
}
 


private boolean checkThisNodeMinMax()//true = max false  = min
{
	this.validMoves = Controller.getValidMoves(this.parent.thisBoard,this.parentMove);
	int row = (validMoves.get(0).getSource()-1)/8;
	int colum = (validMoves.get(0).getSource()-1)%8;
	
	if(parent.thisBoard[row][colum]%2==Node.color)
	{
		return true;
	}
	else
	{
		return false;
	}
	
}
void childGenerator(boolean isRoot)
{
	if(this.level<=maxlevel)
	{
		
		for(int i = 0 ; i<validMoves.size() ; i++)
		{
			
			Node child = new Node(this,validMoves.get(i),this.level+1);
			if(!minMaxStatus&& child.utility[1]<this.utility[1])
			{
				this.utility[1]=child.utility[1];
				this.bestChild=child;
					
			}
			if(minMaxStatus&&(child.utility[0]>this.utility[0]))
			{
				this.utility[0]=child.utility[0];
				this.bestChild=child;
			}
			if(!isRoot)
			{
				if(parent.minMaxStatus&&this.utility[1]<parent.utility[0])
				{
					break;
				}
				if(!parent.minMaxStatus&&this.utility[0]>parent.utility[1])
				{
					break;
				}
				
			}
			
		}
		if(validMoves.size()==0||this.level==maxlevel)
		{
			this.utility[0]=calculateUtility();
			this.utility[1]=this.utility[0];
		}
		else
		{
			
				this.utility[0]=this.bestChild.utility[0];
				this.utility[1]=this.bestChild.utility[1];
				
			
		}
		
	}
}
int calculateUtility()
{
	BoardStatus bs =checkBoardStatus();
	switch (Node.color) {
	case 1:
		return (bs.whitePawn*-1)+(-1*2*bs.whiteKings)+(bs.blackPawn)+(2*bs.blackKings);
	case 2:
		return (bs.whitePawn)+(2*bs.whiteKings)-(bs.blackPawn)-(2*bs.blackKings);
		

	default:
		return 0;
	}
	
}
BoardStatus checkBoardStatus()
{
	BoardStatus bS = new BoardStatus();
	for(int i =0 ; i<8;i++)
	{
		for(int j=0 ; j<8 ;j++)
		{
			switch (this.thisBoard[i][j]) {
			case 1:
				bS.blackPawn++;	
				break;
			case 3:
				bS.blackKings++;
				
				break;
			case 2:
				bS.whitePawn++;
				
				break;
			case 4:
				bS.whiteKings++;
				
				break;

			default:
				break;
			}
		}
	}
	return bS;
}
}