

import java.io.*;
import java.util.*;

import java.awt.List;
import java.util.ArrayList;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;

public class Controller {

	public static void main(String[] args) throws Exception {
		 String crawlStorageFolder = "/home/saket/CSCI572_HW2_crawl_data";



		 int numberOfCrawlers = 1;
		 CrawlConfig config = new CrawlConfig();
		 config.setCrawlStorageFolder(crawlStorageFolder);
         config.setFollowRedirects(true);
         config.setResumableCrawling(false);
         config.setMaxDepthOfCrawling(16);
         config.setMaxPagesToFetch(20000);
         config.setMaxDownloadSize(90000000);
         config.setPolitenessDelay(2000);

		 /*
		 * Instantiate the controller for this crawl.
		 */
		 PageFetcher pageFetcher = new PageFetcher(config);
		 RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
		 RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
		 CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);
		 /*
		 * For each crawl, you need to add some seed urls. These are the first
		 * URLs that are fetched and then the crawler starts following links
		 * which are found in these pages
		 */
		 controller.addSeed("https://news.yahoo.com/");
		 /*
		  * Start the crawl. This is a blocking operation, meaning that your code
		  * will reach the line after this only when crawling is finished.
		  */
		  controller.start(MyCrawler.class, numberOfCrawlers);
          java.util.List<Object> urlDataList = controller.getCrawlersLocalData();

		  LocalDataHandler urlData = new LocalDataHandler();		
         
		  for (Object localData : urlDataList) {
	        	LocalDataHandler crawlerstate = (LocalDataHandler) localData;
	        	urlData.fetchURLs.addAll(crawlerstate.fetchURLs);
	        	urlData.visitURLs.addAll(crawlerstate.visitURLs);
	        	urlData.allURLs.addAll(crawlerstate.allURLs);  
	        	urlData.outgoingURLs.addAll(crawlerstate.outgoingURLs);
	        }
		  writeFetchCSV(urlData.fetchURLs);
		  writeAllCSV(urlData.allURLs);
		  writeVisitCSV(urlData.visitURLs);
		  writeOutgoingCSV(urlData.outgoingURLs);
		  /*
		  long totalLinks = 0;
	        long totalTextSize = 0;
	        int totalProcessedPages = 0;
	        for (Object localData : urlDataList) {
	            CrawlStat stat = (CrawlStat) localData;
	            totalLinks += stat.getTotalLinks();
	            totalTextSize += stat.getTotalTextSize();
	            totalProcessedPages += stat.getTotalProcessedPages();
	        }

	        logger.info("Aggregated Statistics:");
	        logger.info("\tProcessed Pages: {}", totalProcessedPages);
	        logger.info("\tTotal Links found: {}", totalLinks);
	        logger.info("\tTotal Text Size: {}", totalTextSize);*/
		  }	
	
	public static void writeFetchCSV(ArrayList<String> fetchURLs) throws Exception{
		FileWriter writer = new FileWriter("fetch_yahoo.csv");
		writer.append("url,http_status_code");
		writer.append("\n");
		for (String data : fetchURLs) {
            writer.append(data + "\n");
        }
		writer.flush();
		writer.close();
    }
	
	public static void writeVisitCSV(ArrayList<String> visitURLs) throws Exception{
		FileWriter writer = new FileWriter("visit_yahoo.csv");
		writer.append("url,size,outlinks,content_type");
		writer.append("\n");
		for (String data : visitURLs) {
            writer.append(data + "\n");
        }
		writer.flush();
		writer.close();
    }
	
	public static void writeAllCSV(ArrayList<String> allURLs) throws Exception{
		FileWriter writer = new FileWriter("urls_yahoo.csv");
		writer.append("url,status");
		writer.append("\n");
		for (String data : allURLs) {
            writer.append(data + "\n");
        }
		writer.flush();
		writer.close();
    }
	
	public static void writeOutgoingCSV(ArrayList<String> outgoingURLs) throws Exception{
		FileWriter writer = new FileWriter("outgoingurls_yahoo.csv");
		writer.append("url");
		writer.append("\n");
		for (String data : outgoingURLs) {
            writer.append(data + "\n");
        }
		writer.flush();
		writer.close();
    }
	
	
	
	

}


