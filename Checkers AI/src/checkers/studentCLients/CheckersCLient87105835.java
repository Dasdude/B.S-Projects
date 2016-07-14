package checkers.studentCLients;

import java.util.Timer;

import checkers.*;
import checkers.studentCLients.Controller;

public class CheckersCLient87105835 implements CheckersClient{

	int color;
	int [][] refrenceBoard = new int [][] {
			{ 0, 1, 0, 1, 0, 1, 0, 1},
			{ 1, 0, 1, 0, 1, 0, 1, 0},
			{ 0, 1, 0, 1, 0, 1, 0, 1},
			{ 0, 0, 0, 0, 0, 0, 0, 0},
			{ 0, 0, 0, 0, 0, 0, 0, 0},
			{ 2, 0, 2, 0, 2, 0, 2, 0},
			{ 0, 2, 0, 2, 0, 2, 0, 2},
			{ 2, 0, 2, 0, 2, 0, 2, 0}
	};
	Move lastMove;
	public Move getMove() {
		// TODO Auto-generated method stub
		long starttime=System.currentTimeMillis();
		MinMax decisionTree = new MinMax(lastMove,refrenceBoard);
		if(lastMove!=null)
		{
		Controller.updateTable(refrenceBoard, lastMove);
		}
		this.lastMove =decisionTree.getBestMove() ;
		long end = System.currentTimeMillis();
		long duration =end-starttime;
		System.out.println(duration);
		return decisionTree.getBestMove();
	}

	public void boardNotify(Move move) {
		// TODO Auto-generated method stub
		if(lastMove!=null)
			{
			Controller.updateTable(refrenceBoard, lastMove);
			}
		this.lastMove = move;
	}

	public void setColor(int color) {
		// TODO Auto-generated method stub
		this.color = color;
		Node.color=color;
	}
	

}
