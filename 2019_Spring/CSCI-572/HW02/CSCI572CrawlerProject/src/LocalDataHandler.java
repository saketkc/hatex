import java.util.ArrayList;

public class LocalDataHandler {
	ArrayList<String> fetchURLs;
    ArrayList<String> visitURLs;
    ArrayList<String> allURLs;
    ArrayList<String> outgoingURLs;
    
    public LocalDataHandler() {
    	 fetchURLs = new ArrayList<String>();
    	 visitURLs = new ArrayList<String>();
    	 allURLs = new ArrayList<String>();
    	 outgoingURLs =  new ArrayList<String>();
    }

}
