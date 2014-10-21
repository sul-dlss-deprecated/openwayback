package org.archive.wayback.partition;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.archive.wayback.core.CaptureSearchResult;
import org.archive.wayback.core.UIResults;
import org.archive.wayback.util.graph.Graph;
import org.archive.wayback.util.graph.GraphEncoder;
import org.archive.wayback.util.graph.RegionData;
import org.archive.wayback.util.graph.RegionGraphElement;
import org.archive.wayback.util.partition.Partition;
import org.archive.wayback.util.partition.PartitionSize;
import org.archive.wayback.util.partition.Partitioner;

public class InteractiveToolBarData extends ToolBarData {
	
	private static final PartitionSize daySize = Partitioner.daySize;

	private static final CaptureSearchResultPartitionMap dayMap = 
			new CaptureSearchResultPartitionMap();
	private static final Partitioner<CaptureSearchResult> dayPartitioner = 
			new Partitioner<CaptureSearchResult>(dayMap);
	
	public List<Partition<CaptureSearchResult>> dayPartitions;

	public String firstResultReplayUrl;
	public String lastResultReplayUrl;
	
	public InteractiveToolBarData(UIResults uiResults) {
		//super(uiResults);
		this.uiResults = uiResults;
		fmt = uiResults.getWbRequest().getFormatter();
		results = uiResults.getCaptureResults();
		curResult = uiResults.getResult();
		findRelativeLinks();

		Date firstDate = uiResults.getWbRequest().getStartDate();
		Date lastDate = uiResults.getWbRequest().getEndDate();
		yearPartitions = yearPartitioner.getRange(yearSize,firstDate,lastDate);
	
		Date firstYearDate = yearPartitions.get(0).getStart();
		Date lastYearDate = yearPartitions.get(yearPartitions.size()-1).getEnd();
		dayPartitions =
				dayPartitioner.getRange(daySize,firstYearDate,lastYearDate);
		
		Iterator<CaptureSearchResult> it = results.iterator();
		
		firstResultReplayUrl = fmt.escapeHtml(uiResults.resultToReplayUrl(results.getResults().getFirst()));
		lastResultReplayUrl = fmt.escapeHtml(uiResults.resultToReplayUrl(results.getResults().getLast()));
		
		dayPartitioner.populate(dayPartitions,it);
		yearPartitioner.populate(yearPartitions,dayPartitions.iterator());
	}
	
	/**
	 * @param formatKey String template for format Dates
	 * @param width pixel width of resulting graph
	 * @param height pixel height of resulting graph
	 * @return String argument which will generate a graph for the results
	 */
	public String computeGraphString(String formatKey, int width, int height) {
		Graph graph = PartitionsToGraph.partsOfPartsToGraph(yearPartitions,
				fmt,formatKey,width,height);
		
		RegionGraphElement rge[] = graph.getRegions();
		RegionData data[] = new RegionData[rge.length];
		for(int i = 0; i < data.length; i++) {
			data[i] = rge[i].getData();
			
			for(int j=0; j<data[i].getValues().length;j++){
			//	System.out.print(data[i].getValues()[j]+"");
			}
			
			//System.out.println();
		}
		
		return GraphEncoder.encode(graph);

	}
	
}
