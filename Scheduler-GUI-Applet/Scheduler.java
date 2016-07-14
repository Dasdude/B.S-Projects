import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

//import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;


public class Scheduler {
	int time;
	int nextArrivalTime;
	List<PeriodicJob> readyQueue;
	List<PeriodicJob> finishedJob;
	boolean checkQueue;
	PeriodicJob executingJob;
	Plotter gr;
	int schedulingMode; // rate monotonic =1 deadline monotonic = 2 EDF = 3;
	public Scheduler(int schedulingMode ,Plotter gr)
	{
		time=0;
		checkQueue=false;
		this.gr = gr;
		this.schedulingMode = schedulingMode;
		readyQueue = new LinkedList<PeriodicJob>();
		finishedJob = new LinkedList<PeriodicJob>();
		
	}
	void pickJob()
	{
		
		if(!readyQueue.isEmpty())
		{
			switch(schedulingMode){
			case 1:
			{
				Collections.sort(this.readyQueue,new RateComparator());
				break;
			}
			case 2:
			{
				Collections.sort(this.readyQueue,new RelativeDeadlineComparator());
				break;
			}
			case 3:
			{
				Collections.sort(this.readyQueue,new AbsoluteDeadlineComparator());
				break;
			}
			default:
				break;
			}
			executingJob = readyQueue.remove(0);
		}
			
			
	}
	void schedulerRun1Tik()
	{
		time++;
		if(executingJob!=null)
		{
			executingJob.executionTime--;
			System.out.println("job "+executingJob.jClass + " is being Processed \n time :" +this.time+"    CID : "+executingJob.jClass+"    ICPID : " + executingJob.jClassID );
			this.gr.DrawBox(time-1, executingJob.jClass, executingJob.jClassID);
			if(executingJob.executionTime==0)
			{
				executingJob.finished=true;
				finishedJob.add(executingJob);
				executingJob=null;
			}			
		}
	}
	void schedulerRun()
	{
		if(checkQueue||executingJob==null)
		{
			if(executingJob!=null)
				readyQueue.add(executingJob);
			
			
			pickJob();
			checkQueue=false;
		}
		
		schedulerRun1Tik();
	}
	
}
