
public class JobType {
	int period;
	int initialArrival;
	int executionTime;
	int reletiveDeadline;
	int instanceTotal;
	public JobType(int period , int initialArrival ,int executionTime , int reletiveDeadline) {
		// TODO Auto-generated constructor stub
		this.period = period;
		this.initialArrival= initialArrival;
		this.executionTime= executionTime;
		this.reletiveDeadline = reletiveDeadline;
		instanceTotal=0;
	}
}
