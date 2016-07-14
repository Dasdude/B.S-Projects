package checkers;

public class GetMoveTimeLimiter extends Thread{
	CheckersClient player;
	Move result = null;
	int hasException = 0;
	int isFinished = 0;
	Thread waiter = null;
	
	public GetMoveTimeLimiter(CheckersClient client, Thread waiter){
		player = client;
		this.waiter = waiter;
	}
	public void run() {
			try{
				result = player.getMove();
			}catch (Exception e){hasException = 1;}
			isFinished = 1;
			waiter.interrupt();
	};
}
