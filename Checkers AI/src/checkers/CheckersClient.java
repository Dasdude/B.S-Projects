package checkers;

public interface CheckersClient {
	void setColor(int color);
	void boardNotify(Move move);
	Move getMove();
}
