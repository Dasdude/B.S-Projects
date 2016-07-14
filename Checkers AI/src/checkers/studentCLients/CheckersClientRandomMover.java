package checkers.studentCLients;

import java.util.ArrayList;

import checkers.*;

public class CheckersClientRandomMover implements CheckersClient{

	Move lastMove = null;
	int MyColor;
	
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
	
	public void boardNotify(Move newMove) {
		if (lastMove != null)
			Controller.updateTable(boardBeforLastMove, lastMove);
		lastMove = newMove;
	}


	public Move getMove() {
		ArrayList<Move> validMoves = Controller.getValidMoves(boardBeforLastMove, lastMove);
		int r = (int)Math.floor(Math.random() * validMoves.size());
		Move newMove = validMoves.get(r);
		if (lastMove != null)
			Controller.updateTable(boardBeforLastMove, lastMove);
		lastMove = newMove;
		return newMove;
	}

	public void setColor(int color) {
		MyColor = color;
	}

}
