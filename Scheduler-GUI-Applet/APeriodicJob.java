
public class APeriodicJob extends Job {
	int priority;// higher number means higher priority 
	public APeriodicJob(int arrival , int deadline,int executionTime)
	{
		super(arrival,deadline,executionTime);
		priority=0;
	}
	public APeriodicJob(int arrival , int deadline, int priority,int executionTime)
	{
		super(arrival,deadline,executionTime);
		this.priority=priority;
	}
}
