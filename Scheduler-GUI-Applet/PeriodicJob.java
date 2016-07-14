
public class PeriodicJob extends Job {
	int period ; 
	public PeriodicJob(int period , int arrival, int exectionTime) {
		// TODO Auto-generated constructor stub
		super(arrival,period,exectionTime);
		this. period = period;
	}
	public PeriodicJob(JobType type, int arrival) {
		// TODO Auto-generated constructor stub
		super(type,arrival);
		this. period = type.period;
	}

}
