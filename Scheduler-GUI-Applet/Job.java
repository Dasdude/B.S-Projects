
public class Job {
int arrival;
int deadline;
int absoluteDeadline;
int executionTime;
boolean finished;
int remainingTime;
int jClass;
int pid;
int jClassID;
public Job(int arrival , int absoluteDeadline,int executionTime)
{
	this.arrival = arrival;
	this.absoluteDeadline = absoluteDeadline;
	this.finished=false;
	this.deadline= absoluteDeadline-arrival;
	this.remainingTime=executionTime;
	this.executionTime=executionTime;
	
}
public Job(JobType type ,int arrival)
{
	this.arrival = arrival;
	this.absoluteDeadline = arrival+type.reletiveDeadline;
	this.finished=false;
	this.deadline= type.reletiveDeadline;
	this.remainingTime=executionTime;
	this.executionTime=type.executionTime;
	
}
}