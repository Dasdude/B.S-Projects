
package checkers.studentCLients;

import checkers.Move;

public class MinMax {
Node root;
Node bestMoveNode;
MinMax(Move lastMove ,int[][] board)
{
	Node.maxlevel=5;
	root = new Node(lastMove,board);
	System.out.println(root.bestChild);
	this.bestMoveNode=root.bestChild;
	
}
public Move getBestMove()
{
	return this.bestMoveNode.parentMove;
}
public Node getBestMoveNode()
{
	return this.bestMoveNode;
}
}
