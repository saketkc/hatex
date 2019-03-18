import java.util.*;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class InvertedIndexBigram {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, Text>{

    private Text word = new Text();
    private Text docID = new Text();
    private Text docContent = new Text();
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException { 
      //he ‘\t’separates the key(Document ID) from the value(Document)
      String[] tokens = value.toString().split("\\t");
      docID.set(tokens[0]);
      docContent.set(tokens[1]);
      StringTokenizer itr = new StringTokenizer(docContent.toString().replaceAll("[^a-zA-Z0-9]+"," ").toLowerCase());
      String previous = null;
      while (itr.hasMoreTokens()) {
        String current = itr.nextToken();
	if (previous != null) {
		word.set(previous + " " + current);
        	context.write(word, docID);
	}
	previous = current;
        //word.set();
      }
    }
  }

  public static class InvertedIndexBigramReducer
       extends Reducer<Text,Text,Text,Text> {
    private Text docId = new Text();
    public void reduce(Text key, Iterable<Text> values,
                       Context context
                       ) throws IOException, InterruptedException {
      HashMap<String,Integer> invertedIndexHMap = new HashMap<String,Integer>();
      //HashMap<String,Integer> hmap = new HashMap<String,Integer>();

      for (Text val : values) {
        //String valString = val.toString();
	String valString = val.toString();
        if (invertedIndexHMap.containsKey(valString)){
		Integer counts = invertedIndexHMap.get(valString);
		counts = counts + 1;
      		invertedIndexHMap.put(valString, counts);
        }
        else{
          invertedIndexHMap.put(valString, 1);
        }
      }

      //Text result = new Text(invertedIndexHMap.toString());
      StringBuilder sb = new StringBuilder("");
      for(String skey: invertedIndexHMap.keySet()){
	      sb.append(skey+":"+invertedIndexHMap.get(skey)+" ");
      }
      Text result = new Text(sb.toString());
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "inverted index bigram");
    job.setJarByClass(InvertedIndexBigram.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setReducerClass(InvertedIndexBigramReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
