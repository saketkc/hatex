import java.awt.List;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Set;
import java.util.regex.Pattern;

import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.url.WebURL;

public class MyCrawler extends WebCrawler {
 private final static Pattern FILTERS = Pattern.compile(".*(\\.(css|js|gif|jpg"
 + "|png|mp3|mp3|zip|gz))$");
 
 ArrayList<String> fetchURLs = new ArrayList<String>();
 ArrayList<String> visitURLs = new ArrayList<String>();
 ArrayList<String> allURLs = new ArrayList<String>();
 
 ArrayList<String> outgoingURLs = new ArrayList<String>();
 
 LocalDataHandler localData = new LocalDataHandler();
 //PrintWriter fetchyahooCSV = new PrintWriter("fetch_yahoo.csv", "UTF-8");
 //PrintWriter urlsCSV = new PrintWriter("urls_yahoo.csv", "UTF-8");
 
 
 @Override
 public Object getMyLocalData(){
	 return localData;
 };
 /*
 public ArrayList<String>  getfetchURLs() {
	 return fetchURLs;
	 }


public ArrayList<String>  getvisitURLs() {
	return visitURLs;
	}


public ArrayList<String> getallURLs() {
	return allURLs;
	}
	*/

 @Override
 protected void handlePageStatusCode(WebURL webUrl, int statusCode, String statusDescription) {

     fetchURLs.add(webUrl.getURL() + "," + Integer.toString(statusCode));
 }
 /**
 * This method receives two parameters. The first parameter is the page
 * in which we have discovered this new url and the second parameter is
 * the new url. You should implement this function to specify whether
 * the given url should be crawled or not (based on your crawling logic).
 * In this example, we are instructing the crawler to ignore urls that
 * have css, js, git, ... extensions and to only accept urls that start
 * with "http://www.viterbi.usc.edu/". In this case, we didn't need the
 * referringPage parameter to make the decision.
 */
 @Override
 public boolean shouldVisit(Page referringPage, WebURL url) {
	 //arrayList.add(url.getURL());
	 String toWrite = url.getURL() + ",";
	 String validState = "N_OK";
	 String href = url.getURL().toLowerCase();
	 if (!FILTERS.matcher(href).matches()
	 && href.startsWith("https://news.yahoo.com/")){
		 validState = "OK";
		 return true;
	 }
	 localData.allURLs.add(href + "," + validState);
	 return false;
	 }
/**
* This function is called when a page is fetched and ready
* to be processed by your program.
*/
@Override
public void visit(Page page) {
	int statusCode = page.getStatusCode();	
	String url = page.getWebURL().getURL().replaceAll(",", "-");
	localData.fetchURLs.add(url + "," + Integer.toString(statusCode));
	String contentType = page.getContentType().split(";")[0];
	//ArrayList<String> outgoingURLList = new ArrayList<String>();
	System.out.println("URL: " + url);

	String urlBytes = new String(url.getBytes(), StandardCharsets.UTF_8);

	if (contentType.startsWith("text/html")) {
		if (page.getParseData() instanceof HtmlParseData) {

			HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();
			String text = htmlParseData.getText();
			String html = htmlParseData.getHtml();
			Set<WebURL> links = htmlParseData.getOutgoingUrls();
			for (WebURL link : links) {
				//outgoingURLList.add(link.getURL());
				localData.outgoingURLs.add(link.getURL());
				}
			//outgoingURLs.addAll)add
			
			byte[] htmlsize = html.getBytes();
			System.out.println("Text length: " + text.length());
			System.out.println("Content type: " + contentType);
			System.out.println("Html length: " + html.length());
			System.out.println("Number of outgoing links: " + links.size());
			localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + Integer.toString(links.size()) + "," + "text/html");


			}
		}
	else if (contentType.startsWith("application/msword")) {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "application/msword");
		}
	else if (contentType.startsWith("application/pdf")) {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "application/pdf");
		}
	else if (contentType.startsWith("image/gif")) {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "image/gif");
		}
	else if (contentType.startsWith("image/jpeg")) {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "image/jpeg");
		}
	else if (contentType.startsWith("image/png")) {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "image/png");
		}

	else {
		localData.visitURLs.add(url + "," + Integer.toString(page.getContentData().length) + "," + "0" + "," + "unkown-"+contentType);
		}
	}


}
