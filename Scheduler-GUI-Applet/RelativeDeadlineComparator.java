import java.util.Comparator;


public class RelativeDeadlineComparator implements Comparator<PeriodicJob>{
	    @Override
	    public int compare(PeriodicJob a, PeriodicJob b) {
	        return a.deadline < b.deadline ? -1 : a.deadline == b.deadline ? 0 : 1;
	    }
}
