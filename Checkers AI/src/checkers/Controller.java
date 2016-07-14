package checkers;
import java.util.ArrayList;
import java.util.Scanner;
import checkers.studentCLients.*;


public class Controller {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CheckersClient B = new CheckersCLient87105835();
		CheckersClient A = new CheckersClientRandomMover();
		
		System.out.println(playMatch(A,B));
/*
		
		CheckersClient [] players = {
//				new CheckersClient89104245(),
//				new CheckersCLient90105691(),
//				new CheckersClient90105764(),
//				new CheckersCLient90105872(),
//				new CheckersCLient90109936(),
				new CheckersClientRandomMover(),
				new CheckersClientRandomMover()
		};
		

		int playersNum = players.length;
		
		String[][] results = new String[playersNum][playersNum];
		
		
		PrintStream fout = null;
		try {
			fout = new PrintStream(new File("output.txt"));
		} catch (FileNotFoundException e) {}
		
		for (int i=0; i<playersNum; i++)
			for (int j=0; j<playersNum; j++)
				if (i != j)
				{
					results[i][j] = playMatch(players[i],players[j]);
					fout.println(i + " Vs " + j + " :  " + results[i][j] + "\n =========================== \n");
					System.out.println(i + " Vs " + j + " :  " + results[i][j] + "\n =========================== \n");
				}
*/
	}
	
	public static String playMatch(CheckersClient A, CheckersClient B){
		Move lastMove = null;
		int [][] board = new int [][] {
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 1, 0, 1, 0, 1, 0, 1, 0},
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 2, 0, 2, 0, 2, 0, 2, 0},
				{ 0, 2, 0, 2, 0, 2, 0, 2},
				{ 2, 0, 2, 0, 2, 0, 2, 0}
		};
		int [][] boardBeforLastMove = new int [][] {
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 1, 0, 1, 0, 1, 0, 1, 0},
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 2, 0, 2, 0, 2, 0, 2, 0},
				{ 0, 2, 0, 2, 0, 2, 0, 2},
				{ 2, 0, 2, 0, 2, 0, 2, 0}
		}; 

		boolean setColorA = true, setColorB = true;
		
		try{
			A.setColor(1);
		}catch (Exception e){
			setColorA = false;
		}
		try{
			B.setColor(2);	
		}catch (Exception e){
			setColorB = false;
		}
		
		if (!setColorA && !setColorB)
			return ("No Winner: both players throw exception in setColor method.");
		if (!setColorA)
			return ("2 Won: exception thrown by 1 in setColor method.");
		if (!setColorB)
			return ("1 Won: exception thrown by 2 in setColor method.");
		
//		Scanner sc = new Scanner(System.in);
		
		while (true){
			
			System.out.print('.');
			
			ArrayList<Move> validMoves = getValidMoves(boardBeforLastMove, lastMove);
//			for (Move move : validMoves) {
//				System.out.println("move: " + move.getSource() + " , " + move.getDestination());
//			}
			int source = validMoves.get(0).getSource();
			int tmp = board[ (source - 1) / 8][ (source - 1) % 8];
			int turn = 1;
			if (tmp == 2 || tmp == 4)
				turn = 2;
			else if (tmp == 0)
			{
				System.out.println("Error in detecting the turn!!");
				System.exit(1);
			}
			
//			for(int i = 0; i < 8 ; i++){
//				for(int j = 0 ; j < 8 ; j++){
//					System.out.print(board[i][j] + "\t");
//				}
//				System.out.println("\n");
//			}
//			System.out.println(turn + "---------------------");
//			sc.nextInt();
			
			
			CheckersClient Ap, Bp;
			if (turn == 1)
			{
				Ap = A;		Bp = B;
			}
			else
			{
				Ap = B;		Bp = A;
			}
			
			Move currMove;
			GetMoveTimeLimiter getMoveTimeLimiter = new GetMoveTimeLimiter(Ap, Thread.currentThread());
			getMoveTimeLimiter.start();
			try {
				Thread.sleep(1100);
			} catch (InterruptedException e1) {}
			if (getMoveTimeLimiter.isFinished == 0)
				return new String((3-turn) + " Won: time exceeded by player " + turn + " in getMove method.");
			if (getMoveTimeLimiter.hasException == 1)
				return new String((3-turn) + " Won: exception thrown by player " + turn + " in getMove method.");
			currMove = getMoveTimeLimiter.result;
			
//			System.out.println("Suggested Move: " + currMove.getSource() + " , " + currMove.getDestination());
			
			if (!isValidMove(boardBeforLastMove, lastMove, currMove))
			{
				return new String((3-turn) + " Won: invalid move by player " + turn + ".");
			}
			
			if (isFinished(board, currMove))
				return new String(turn + " Won: the game finished.");
			
			updateTable(board, currMove);
			if (lastMove != null)
				updateTable(boardBeforLastMove, lastMove);
			lastMove = currMove;
			
			BoardNotifyTimeLimiter notifyTimeLimiter = new BoardNotifyTimeLimiter(Bp, currMove, Thread.currentThread());
			notifyTimeLimiter.start();
			try {
				Thread.sleep(20);
			} catch (InterruptedException e) {}
			
			if (notifyTimeLimiter.hasException == 1)
				return new String(turn + " Won: exception thrown by player " + (3-turn) + " in boardNotify method.");
			if (notifyTimeLimiter.isFinished == 0)
				return new String(turn + " Won: time exceeded by player " + (3-turn) + " in boardNotiry method.");
		}
	}

	
	
		
	public static void playInInteractiveMode(){
	
		Scanner input = new Scanner(System.in);
		Move lastMove = null;
		int [][] board = new int [][] {
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 1, 0, 1, 0, 1, 0, 1, 0},
				{ 0, 1, 0, 1, 0, 1, 0, 1},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 0, 0, 0, 0, 0, 0, 0, 0},
				{ 2, 0, 2, 0, 2, 0, 2, 0},
				{ 0, 2, 0, 2, 0, 2, 0, 2},
				{ 2, 0, 2, 0, 2, 0, 2, 0}
		};
		
		ArrayList<Move> validMoves = getValidMoves(board, lastMove);
		
		for (int i = 1 ; i < 1000 ; i++){
			for(int j = 0; j < 8 ; j++){
				for(int k = 0 ; k < 8 ; k++){
					System.out.print(board[j][k] + "\t");
				}
				System.out.println("\n");
			}
			System.out.println("---------------------");
			
			//printing moves
			System.out.println("size of moves = "+validMoves.size());
			for (int j =0; j < validMoves.size(); j++){
				System.out.print( "from " + (((validMoves.get(j).getSource()-1) / 8) + 1)+ "," + (((validMoves.get(j).getSource()-1) % 8) + 1) + "   to  ");
				System.out.println( (((validMoves.get(j).getDestination()-1) / 8) + 1) + "," + (((validMoves.get(j).getDestination()-1) % 8) + 1));
			}

			int sourceRow = input.nextInt(), sourceCol = input.nextInt(), destRow = input.nextInt(), destCol = input.nextInt();
			lastMove = new Move(8*(sourceRow-1) + sourceCol, 8*(destRow-1)+destCol);

			validMoves = getValidMoves(board, lastMove);
			updateTable(board,lastMove);

			//board = update table

		}


		System.out.println("size of moves = "+validMoves.size());
		for (int i =0; i < validMoves.size(); i++){
			System.out.print( validMoves.get(i).getSource()+ " ");
			System.out.println(validMoves.get(i).getDestination());

		}

	}	
	
	
	
	
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

	
	private static boolean isFinished(int[][] boardBeforLastMove, Move lastMove){
		ArrayList<Move> validMoves = getValidMoves(boardBeforLastMove, lastMove);
		return validMoves.isEmpty();
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
			int xStep = (destinationRow - sourceRow)/Math.abs((destinationRow - sourceRow));
			int yStep = (destinationColumn - sourceColumn)/Math.abs(destinationColumn - sourceColumn);
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
			int xStep = (destinationRow - sourceRow)/Math.abs((destinationRow - sourceRow));
			int yStep = (destinationColumn - sourceColumn)/Math.abs(destinationColumn - sourceColumn);
			updatedBoard[sourceRow+xStep][sourceColumn+yStep] = 0;
			updatedBoard[sourceRow + 2*xStep][sourceColumn+2*yStep]= 0;
		}
		updatedBoard [sourceRow][sourceColumn] = 0;
		
		for (int i=0; i<8; i++)
			for (int j=0; j<8; j++)
				boardBeforLastMove [i][j] = updatedBoard [i][j];
	}
	
	private static boolean isValidMove(int[][] boardBeforLastMove, Move lastMove, Move currentMove){
		ArrayList<Move> validMoves = getValidMoves(boardBeforLastMove, lastMove);
		for (Move move : validMoves) {
			if (currentMove.getSource() == move.getSource() && currentMove.getDestination() == move.getDestination())
				return true;
		}
		return false;
	}

}
