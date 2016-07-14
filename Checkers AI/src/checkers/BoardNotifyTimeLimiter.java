package checkers;

public class BoardNotifyTimeLimiter extends Thread{
	CheckersClient player;
	Move newMove = null;
	int isFinished = 0;
	int hasException = 0;
	Thread waiter;
	
	public BoardNotifyTimeLimiter(CheckersClient client, Move newMove, Thread waiter){
		this.newMove = newMove;
		player = client;
		this.waiter = waiter;
	}
	public void run() {
			try{
				player.boardNotify(newMove);
			}catch (Exception e){hasException = 1;}
			isFinished = 1;
			waiter.interrupt();
	};
}