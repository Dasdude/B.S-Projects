import java.util.Comparator;


public class AbsoluteDeadlineComparator implements Comparator<PeriodicJob>{
	    @Override
	    public int compare(PeriodicJob a, PeriodicJob b) {
	        return a.absoluteDeadline < b.absoluteDeadline ? -1 : a.absoluteDeadline == b.absoluteDeadline ? 0 : 1;
	    }
}
