package checkers.studentCLients;
import java.util.ArrayList;
import java.util.Scanner;

import checkers.*;
import checkers.studentCLients.*;


public class Controller {

	/**
	 * @param args
	 */

	public static ArrayList<Move> getValidMoves(int[][] boardBeforLastMove, Move lastMove){

		ArrayList<Move> moves = new ArrayList<Move>();
		
		if(lastMove==null){
			for(int j = 0; j < 8; j++){
				ArrayList<Move> legalMoves = getLegalPeacefulMoves(boardBeforLastMove,2,j);
				for(int k = 0; k < legalMoves.size(); k++){
					moves.add(legalMoves.get(k));				
				}
				
			}
			return moves;
		}
		
		int sourceRow = (lastMove.getSource()-1)/8;
		int sourceColumn = (lastMove.getSource() - 1) %8 ;
		int destinationRow = (lastMove.getDestination()-1)/8;
		int destinationColumn = (lastMove.getDestination()-1)%8;

		//update the board
		
		int [][] updatedBoard = new int [8][8];
		for (int i=0; i<8; i++)
			for (int j=0; j<8 ; j++)
				updatedBoard[i][j] = boardBeforLastMove[i][j];
		updateTable(updatedBoard,lastMove);

		
		
		//if we can do multiple moves
		if (actionMove(boardBeforLastMove,lastMove)){  //last move has eliminated a man
			moves = getLegalAttackMoves(updatedBoard,destinationRow,destinationColumn);
			if (moves.size() > 0)
				return moves;
		}



		//if we have to attack
		int player = oppositePlayer(updatedBoard [destinationRow][destinationColumn]);
		for(int i = 0 ; i < 8 ; i++)
			for(int j = 0; j < 8; j++){

				if(thisPlayer(updatedBoard[i][j])==player){
					ArrayList<Move> legalMoves = getLegalAttackMoves(updatedBoard,i,j);
					if(legalMoves.size()!=0){
						for (int k=0; k < legalMoves.size(); k++){
							moves.add(legalMoves.get(k));
						}

					}
				}
			}

		if(moves.size()!=0)
			return moves;


		//if we can move piece without eliminating
		for(int i = 0 ; i < 8 ; i++)
			for(int j = 0; j < 8; j++){
				if(thisPlayer(updatedBoard[i][j])==player){
					ArrayList<Move> legalMoves = getLegalPeacefulMoves(updatedBoard,i,j);
					for(int k = 0; k < legalMoves.size(); k++){
						moves.add(legalMoves.get(k));
					}
				}
			}


		return moves;
	}		


	private static ArrayList<Move> getLegalPeacefulMoves(int[][] board, int row, int column) {

		ArrayList<Move> moves = new ArrayList<Move>();

		//short move for man black
		if(board[row][column]==1){
			if(boardLegal(board,row+1,column+1)){
				Move move = new Move(row*8+column+1,(row+1)*8+column+2);
				moves.add(move);
			}
			if(boardLegal(board, row+1,column-1)){
				Move move = new Move(row*8+column+1,(row+1)*8+column);
				moves.add(move);
			}
		}


		//short move for man white
		if(board[row][column]==2){

			if(boardLegal(board,row-1,column-1)){
				Move move = new Move(row*8+column+1,(row-1)*8+column);
				moves.add(move);
			}
			if(boardLegal(board,row-1,column+1)){						
				Move move = new Move(row*8+column+1,(row-1)*8+column+2);
				moves.add(move);
			}

		}


		//moves for king
		else if(board[row][column]==3 || board[row][column]==4){


			//consider short moves for king
			if(boardLegal(board,row+1,column+1)){
				Move move = new Move(row*8+column+1,(row+1)*8+column+2);
				moves.add(move);
			}
			if(boardLegal(board,row+1,column-1)){
				Move move = new Move(row*8+column+1,(row+1)*8+column);
				moves.add(move);
			}
			if(boardLegal(board,row-1,column-1)){
				Move move = new Move(row*8+column+1,(row-1)*8+column);
				moves.add(move);
			}
			if(boardLegal(board, row-1,column+1)){
				Move move = new Move(row*8+column+1,(row-1)*8+column+2);
				moves.add(move);
			}


			//consider long move for king
			if(boardLegal(board,row+2,column+2)){
				if(board[row+1][column+1] == 0){ 
					Move move = new Move(row*8+column+1,(row+2)*8+column+3);
					moves.add(move);
				}
			}
			if(boardLegal(board,row+2,column-2)){
				if(board[row+1][column-1] == 0){ 
					Move move = new Move(row*8+column+1,(row+2)*8+column-1);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-2,column-2)){
				if(board[row-1][column-1] == 0){ 
					Move move = new Move(row*8+column+1,(row-2)*8+column-1);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-2,column+2)){
				if(board[row-1][column+1] == 0){ 
					Move move = new Move(row*8+column+1,(row-2)*8+column+3);
					moves.add(move);
				}
			}
		}

		return moves;

	}


	private static ArrayList<Move> getLegalAttackMoves (int [][]board, int row, int column){
		ArrayList<Move> moves = new ArrayList<Move>();


		//short move for man black
		if(board[row][column]==1){	
			if(boardLegal(board,row+2,column+2)){
				if(thisPlayer(board[row+1][column+1])==2) {
					Move move = new Move(row*8+column+1,(row+2)*8+column+3);
					moves.add(move);
				}
			}
			if(boardLegal(board, row+2,column-2)){
				if(thisPlayer(board[row+1][column-1])==2){
					Move move = new Move(row*8+column+1,(row+2)*8+column-1);
					moves.add(move);
				}
			}

		}


		//short move for man white
		if(board[row][column]==2){
			if(boardLegal(board,row-2,column-2)){
				if(thisPlayer(board[row-1][column-1])==1){
					Move move = new Move(row*8+column+1,(row-2)*8+column-1);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-2,column+2)){
				if(thisPlayer(board[row-1][column+1])==1) {
					Move move = new Move(row*8+column+1,(row-2)*8+column+3);
					moves.add(move);
				}
			}

		}



		//moves for king
		else if(board[row][column]==3 || board[row][column]==4){
			//consider short moves for king
			int player = thisPlayer(board[row][column]);
			int OppositePlayer = oppositePlayer(board[row][column]) ;
			if(boardLegal(board,row+2,column+2)){
				if(thisPlayer(board[row+1][column+1]) == OppositePlayer){
					Move move = new Move(row*8+column+1,(row+2)*8+column+3);
					moves.add(move);
				}
			}
			if(boardLegal(board,row+2,column-2)){
				if(thisPlayer(board[row+1][column-1]) == OppositePlayer){
					Move move = new Move(row*8+column+1,(row+2)*8+column-1);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-2,column-2)){
				if(thisPlayer(board[row-1][column-1]) == OppositePlayer) {
					Move move = new Move(row*8+column+1,(row-2)*8+column-1);
					moves.add(move);
				}
			}
			if(boardLegal(board, row-2,column+2)){
				if(thisPlayer(board[row-1][column+1]) == OppositePlayer){
					Move move = new Move(row*8+column+1,(row-2)*8+column+3);
					moves.add(move);
				}
			}


			//consider long move for king
			if(boardLegal(board,row+3,column+3)){
				if(((thisPlayer(board[row+1][column+1]) == OppositePlayer) && board[row+2][column+2]== 0) ||
						((thisPlayer(board[row+2][column+2]) == OppositePlayer) && board[row+1][column+1]==0)){
					Move move = new Move(row*8+column+1,(row+3)*8+column+4);
					moves.add(move);
				}
			}
			if(boardLegal(board,row+3,column-3)){
				if(((thisPlayer(board[row+1][column-1]) == OppositePlayer) && board[row+2][column-2]== 0) ||
						((thisPlayer(board[row+2][column-2]) == OppositePlayer) && board[row+1][column-1]== 0)){
					Move move = new Move(row*8+column+1,(row+3)*8+column-2);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-3,column-3)){
				if(((thisPlayer(board[row-1][column-1]) == OppositePlayer) && board[row-2][column-2]==0) ||
						((thisPlayer(board[row-2][column-2]) == OppositePlayer) && board[row-1][column-1]==0)){
					Move move = new Move(row*8+column+1,(row-3)*8+column-2);
					moves.add(move);
				}
			}
			if(boardLegal(board,row-3,column+3)){
				if(((thisPlayer(board[row-1][column+1]) == OppositePlayer) && board[row-2][column+2]==0) ||
						((thisPlayer(board[row-2][column+2]) == OppositePlayer) && board[row-1][column+1]==0)){
					Move move = new Move(row*8+column+1,(row-3)*8+column+4);
					moves.add(move);
				}
			}
		}

		return moves;
	}

	private static boolean boardLegal(int [] [] board, int row, int column) {
		if(-1<row && row<8 && -1<column && column<8)
			if (board[row][column]==0)
				return true;	
		return false;
	}

	private static int oppositePlayer (int player){
		if (player == 3 || player == 1)
			return 2;
		else if(player == 2 || player == 4)
			return 1;
		else
			return 0;
	}

	private static int thisPlayer (int player){
		if (player == 3 || player == 1)
			return 1;
		else if (player == 2 || player == 4)
			return 2;
		else
			return 0;
	}

	private static boolean actionMove (int [] [] board, Move lastMove){

		int sourceRow = (lastMove.getSource()-1)/8;
		int sourceColumn = (lastMove.getSource() - 1) %8 ;
		int destinationRow = (lastMove.getDestination()-1)/8;
		int destinationColumn = (lastMove.getDestination()-1)%8;
		if(Math.abs(destinationRow-sourceRow)==1)
			return false;
		else if(Math.abs(destinationRow-sourceRow)==2){
			if(board[(destinationRow+sourceRow)/2][(destinationColumn+sourceColumn)/2]!=0)
				return true;
		}
		else{
			int xStep = (destinationRow - sourceRow)%3;
			int yStep = (destinationColumn - sourceColumn)%3;
			if(board[sourceRow+xStep][sourceColumn+yStep] != 0 ||
					board[sourceRow + 2*xStep][sourceColumn+2*yStep]!= 0)
				return true;
		}
		return false;
	}

	public static void updateTable(int[][] boardBeforLastMove, Move lastMove){

		
		int sourceRow = (lastMove.getSource()-1)/8 ;
		int sourceColumn = (lastMove.getSource() - 1) %8 ;
		int destinationRow = (lastMove.getDestination()-1)/8;
		int destinationColumn = (lastMove.getDestination()-1)%8;
		
		
		//update the board
		int [][] updatedBoard = new int [8][8];
		for (int i=0; i<8; i++)
			for (int j=0; j<8; j++)
				updatedBoard [i][j] = boardBeforLastMove [i][j];
		
		updatedBoard [destinationRow][destinationColumn] = boardBeforLastMove [sourceRow][sourceColumn];
				
		if (destinationRow == 7 && updatedBoard[destinationRow][destinationColumn]==1)
			updatedBoard[destinationRow][destinationColumn] = 3;
		if (destinationRow == 0 && updatedBoard[destinationRow][destinationColumn]==2)
			updatedBoard[destinationRow][destinationColumn] = 4;
		
		
		if(Math.abs(destinationRow-sourceRow)==2){
			updatedBoard[(destinationRow+sourceRow)/2][(destinationColumn+sourceColumn)/2]=0;
		}
		else if (Math.abs(destinationRow-sourceRow)==3){
			int xStep = (destinationRow - sourceRow)%3;
			int yStep = (destinationColumn - sourceColumn)%3;
			updatedBoard[sourceRow+xStep][sourceColumn+yStep] = 0;
			updatedBoard[sourceRow + 2*xStep][sourceColumn+2*yStep]= 0;
		}
		updatedBoard [sourceRow][sourceColumn] = 0;
		
		for (int i=0; i<8; i++)
			for (int j=0; j<8; j++)
				boardBeforLastMove [i][j] = updatedBoard [i][j];
	}

}
