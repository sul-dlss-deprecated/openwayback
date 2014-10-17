package org.archive.wayback.partition;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.archive.wayback.core.CaptureSearchResult;
import org.archive.wayback.core.UIResults;
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

	public InteractiveToolBarData(UIResults uiResults) {
		super(uiResults);


		Date firstYearDate = yearPartitions.get(0).getStart();
		Date lastYearDate = yearPartitions.get(yearPartitions.size()-1).getEnd();

		dayPartitions =
				dayPartitioner.getRange(daySize,firstYearDate,lastYearDate);

		Iterator<CaptureSearchResult> it = results.iterator();

		dayPartitioner.populate(dayPartitions,it);
		yearPartitioner.populate(yearPartitions,dayPartitions.iterator());
	
	}

}
