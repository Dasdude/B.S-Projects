import java.util.Comparator;


public class RateComparator implements Comparator<PeriodicJob>{
	    @Override
	    public int compare(PeriodicJob a, PeriodicJob b) {
	        return a.period < b.period ? -1 : a.period == b.period ? 0 : 1;
	    }
}
