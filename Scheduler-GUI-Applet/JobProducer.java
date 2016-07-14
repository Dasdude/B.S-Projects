import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;


public class JobProducer {
	LinkedList<JobType> types;
	int time; 
	Scheduler sched;
	int timespan;
	Plotter pl;
	public JobProducer(int timespan , LinkedList<JobType> types , int method,Plotter runThis) {
		// TODO Auto-generated constructor stub
		this.timespan=timespan;
		this.types = types;
		sched = new Scheduler(method,runThis);
		this.pl=runThis;
	}
	void jobProducerRun()
	{
		while(time!=timespan-1)
		{
			this.addJob();
			sched.schedulerRun();
		}
		
	}
	void addJob()
	{
		time = sched.time;
		for(int i =0 ; i<types.size() ; i++)
		{
			if((time -types.get(i).initialArrival)%types.get(i).period==0)
			{
				PeriodicJob j = new PeriodicJob(types.get(i),time);
				j.jClass=i;
				types.get(i).instanceTotal++;
				j.jClassID=types.get(i).instanceTotal;
				System.out.println("Job Added \n Class Id="+i+ "interclass PID : "+j.jClassID+"\n");
				sched.readyQueue.add(j);
				int[] a = {time,j.jClass};
				pl.arrivalTimes.add(a);
				sched.checkQueue=true;
				
			}
		}
	}
	
}
