<%@   page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"
%><%@ page import="java.util.Iterator"
%><%@ page import="java.util.ArrayList"
%><%@ page import="java.util.Date"
%><%@ page import="java.util.Calendar"
%><%@ page import="java.util.List"
%><%@ page import="java.text.ParseException"
%><%@ page import="org.archive.wayback.ResultURIConverter"
%><%@ page import="org.archive.wayback.WaybackConstants"
%><%@ page import="org.archive.wayback.core.CaptureSearchResult"
%><%@ page import="org.archive.wayback.core.CaptureSearchResults"
%><%@ page import="org.archive.wayback.core.UIResults"
%><%@ page import="org.archive.wayback.core.WaybackRequest"
%><%@ page import="org.archive.wayback.partition.CaptureSearchResultPartitionMap"
%><%@ page import="org.archive.wayback.partition.PartitionPartitionMap"
%><%@ page import="org.archive.wayback.partition.PartitionsToGraph"
%><%@ page import="org.archive.wayback.partition.InteractiveToolBarData"
%><%@ page import="org.archive.wayback.util.graph.Graph"
%><%@ page import="org.archive.wayback.util.graph.GraphEncoder"
%><%@ page import="org.archive.wayback.util.graph.GraphRenderer"
%><%@ page import="org.archive.wayback.util.partition.Partition"
%><%@ page import="org.archive.wayback.util.partition.Partitioner"
%><%@ page import="org.archive.wayback.util.partition.PartitionSize"
%><%@ page import="org.archive.wayback.util.StringFormatter"
%><%@ page import="org.archive.wayback.util.url.UrlOperations"
%><%
UIResults results = UIResults.extractReplay(request);
WaybackRequest wbRequest = results.getWbRequest();
ResultURIConverter uriConverter = results.getURIConverter();
StringFormatter fmt = wbRequest.getFormatter();

String staticPrefix = results.getStaticPrefix();
String queryPrefix = results.getQueryPrefix();
String replayPrefix = results.getReplayPrefix();

String graphJspPrefix = results.getContextConfig("graphJspPrefix");
if(graphJspPrefix == null) {
	graphJspPrefix = queryPrefix;
}
InteractiveToolBarData data = new InteractiveToolBarData(results);

String searchUrl = 
	UrlOperations.stripDefaultPortFromUrl(wbRequest.getRequestUrl());
String searchUrlSafe = fmt.escapeHtml(searchUrl);
String searchUrlJS = fmt.escapeJavaScript(searchUrl);
Date firstYearDate = data.yearPartitions.get(0).getStart();
Date lastYearDate = data.yearPartitions.get(data.yearPartitions.size()-1).getEnd();

int resultIndex = 1;
int imgWidth = 0;
int imgHeight = 27;
int monthWidth = 2;
int yearWidth = 25;

for (int year = 1991; year <= Calendar.getInstance().get(Calendar.YEAR); year++)
    imgWidth += yearWidth;

String yearFormatKey = "PartitionSize.dateHeader.yearGraphLabel";
String encodedGraph = data.computeGraphString(yearFormatKey,imgWidth,imgHeight);

String graphImgUrl = graphJspPrefix + "jsp/graph.jsp?graphdata=" + encodedGraph;
// TODO: this is archivalUrl specific:
String starLink = fmt.escapeHtml(queryPrefix + wbRequest.getReplayTimestamp() + 
		"*/" + searchUrl);
%>
<!-- BEGIN WAYBACK TOOLBAR INSERT -->

  <!-- Customized Stanford Wayback Machine CSS -->
  <link href="<%= staticPrefix %>css/su-wayback-toolbar.css" media="all" rel="stylesheet" type="text/css" />
  
<script type="text/javascript" src="<%= staticPrefix %>js/disclaim-element.js" ></script>
<script type="text/javascript" src="<%= staticPrefix %>js/graph-calc.js" ></script>
<script type="text/javascript" src="<%= staticPrefix %>jflot/jquery.min.js" ></script>

<!-- Stanford Wayback show/hide toggle -->
<script type="text/javascript">
  $().ready(function(){
    $("#su-wayback-machine-visibility-toggle").click(function() {
      $(this).text($(this).text() == 'Show overlay' ? 'Hide overlay' : 'Show overlay');
      $("#su-wayback-machine-toolbar-info").toggle();
      return false;
    });
  });
</script>

<script type="text/javascript">
var firstDate = <%= firstYearDate.getTime() %>;
var lastDate = <%= lastYearDate.getTime() %>;
var wbPrefix = "<%= replayPrefix %>";
var wbCurrentUrl = "<%= searchUrlJS %>";

var curYear = -1;
var curMonth = -1;
var yearCount = 15;
var firstYear = 1991;
var imgWidth=<%= imgWidth %>;
var yearImgWidth = <%= yearWidth %>;
var monthImgWidth = <%= monthWidth %>;
var trackerVal = "none";
var displayDay = "<%= fmt.format("ToolBar.curDayText",data.curResult.getCaptureDate()) %>";
var displayMonth = "<%= fmt.format("ToolBar.curMonthText",data.curResult.getCaptureDate()) %>";
var displayYear = "<%= fmt.format("ToolBar.curYearText",data.curResult.getCaptureDate()) %>";
var prettyMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

function showTrackers(val) {
	if(val == trackerVal) {
		return;
	}
	if(val == "inline") {
		document.getElementById("displayYearEl").style.color = "#ec008c";
		document.getElementById("displayMonthEl").style.color = "#ec008c";
		document.getElementById("displayDayEl").style.color = "#ec008c";		
	} else {
		document.getElementById("displayYearEl").innerHTML = displayYear;
		document.getElementById("displayYearEl").style.color = "#ff0";
		document.getElementById("displayMonthEl").innerHTML = displayMonth;
		document.getElementById("displayMonthEl").style.color = "#ff0";
		document.getElementById("displayDayEl").innerHTML = displayDay;
		document.getElementById("displayDayEl").style.color = "#ff0";
	}
   document.getElementById("wbMouseTrackYearImg").style.display = val;
   document.getElementById("wbMouseTrackMonthImg").style.display = val;
   trackerVal = val;
}
function getElementX2(obj) {
	var thing = jQuery(obj);
	if((thing == undefined) 
			|| (typeof thing == "undefined") 
			|| (typeof thing.offset == "undefined")) {
		return getElementX(obj);
	}
	return Math.round(thing.offset().left);
}
function trackMouseMove(event,element) {

   var eventX = getEventX(event);
   var elementX = getElementX2(element);
   var xOff = eventX - elementX;
	if(xOff < 0) {
		xOff = 0;
	} else if(xOff > imgWidth) {
		xOff = imgWidth;
	}
   var monthOff = xOff % yearImgWidth;

   var year = Math.floor(xOff / yearImgWidth);
	var yearStart = year * yearImgWidth;
   var monthOfYear = Math.floor(monthOff / monthImgWidth);
   if(monthOfYear > 11) {
       monthOfYear = 11;
   }
   // 1 extra border pixel at the left edge of the year:
   var month = (year * 12) + monthOfYear;
   var day = 1;
	if(monthOff % 2 == 1) {
		day = 15;
	}
	var dateString = 
		zeroPad(year + firstYear) + 
		zeroPad(monthOfYear+1,2) +
		zeroPad(day,2) + "000000";

	var monthString = prettyMonths[monthOfYear];
	document.getElementById("displayYearEl").innerHTML = year + 1991;
	document.getElementById("displayMonthEl").innerHTML = monthString;
	// looks too jarring when it changes..
	//document.getElementById("displayDayEl").innerHTML = zeroPad(day,2);

	var url = wbPrefix + dateString + '/' +  wbCurrentUrl;
	document.getElementById('wm-graph-anchor').href = url;

   //document.getElementById("wmtbURL").value="evX("+eventX+") elX("+elementX+") xO("+xOff+") y("+year+") m("+month+") monthOff("+monthOff+") DS("+dateString+") Moy("+monthOfYear+") ms("+monthString+")";
   if(curYear != year) {
       var yrOff = year * yearImgWidth;
       document.getElementById("wbMouseTrackYearImg").style.left = yrOff + "px";
       curYear = year;
   }
   if(curMonth != month) {
       var mtOff = year + (month * monthImgWidth) + 1;
       document.getElementById("wbMouseTrackMonthImg").style.left = mtOff + "px";
       curMonth = month;
   }
}
</script>


<!-- Ahmed Alsum modification for converting timemap into json
You can call this method by convertTimemapToJson(<%= encodedGraph %>)
 -->
<script type="text/javascript">
	
function daysInMonth(month,year) {
   return new Date(year, month, 0).getDate();
}

function sumDigitString(digits){
	
	var sum = 0;
	for(var i=0; i< digits.length; i++){
		var digit = digits[i];
		sum = sum + parseInt(digit,16);
	}
	return sum;
}
function convetTimemapToJson(timemap_str) {
	
	var years_json={};
	var months_json={};
	var days_json={};
	
   //Test variable //timemap_str="600_27_1991:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000_1992:120:000000000000000000000000000000000000000000000000000000000000000001000000000001000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1993:-1:00000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000_1994:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1995:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1996:-1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1997:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1998:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_1999:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2000:-1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2001:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2002:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2003:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2004:-1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2005:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2006:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2007:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2008:-1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2009:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2010:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2011:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2012:-1:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2013:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000_2014:-1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	years_list = timemap_str.split("_");
	
	for(var i=2;i<years_list.length;i++){
		
		var year_record = years_list[i].split(":");
		var year = year_record[0];
		var year_digits = year_record[2];
		
		var detailed_month_json={};
		var sum_month_json={};
		var sum_year=0;
		
		var last_index = 0;
		for(var month=1;month<=12;month++){
			
			no_of_days = daysInMonth(month,parseInt(year));
			month_digit = year_digits.substring(last_index,last_index+no_of_days);
			last_index=last_index+no_of_days;

			var month_sum = sumDigitString(month_digit);
			sum_year = sum_year+month_sum;
			detailed_month_json[month]=month_digit;
			sum_month_json[month]=month_sum;
		}
		days_json[year]=detailed_month_json;
		months_json[year]=sum_month_json;
		years_json[year]=sum_year;
	}
	     
	//console.log(years_json);
}
</script>


<style type="text/css">body{margin-top:0!important;padding-top:0!important;min-width:800px!important;}#wm-ipp a:hover{text-decoration:underline!important;}</style>
<div id="wm-ipp" style="display:none; position:relative;padding:0;min-height:70px;min-width:800px; z-index:9000; margin: 0 30px;">
  <div id="wm-ipp-inside" 
    style="position:fixed;padding: 0!important;margin:0!important;
          width:96%;min-width:780px;
          border: 2px solid #999; border-top:none;
          border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;
          background-color: #990000;
          text-align:center;
          font-size:12px!important;font-family:'Lucida Grande','Arial',sans-serif!important;">

          <div id="su-wayback-machine-sul-logo" style="padding: 6px 12px 12px; height: 36px;">
            <span style="display: inline-block; float: left;">
              <a href="http://library.stanford.edu" title="Stanford University Library homepage">
                <img src="<%= staticPrefix %>images/toolbar/SUL-Logo-white-text-h25.png" alt="Wayback Machine" width="297" height="25" border="0" />
              </a>
            </span>
            <span class="su-wayback-machine-toolbar-actions"
                  style="display: inline-block; float: right; padding-top: 3px;
                        font-size: 13px;
                        font-family:'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif!important;">
              <span class="current-capture-info"
                    style="color: #ddd;">
                Showing 
                <span style="text-decoration: underline;">
                  <%= searchUrlSafe %>
                </span> 
                captured on
                <%= fmt.format("ToolBar.curMonthText",data.curResult.getCaptureDate()) %>
                <%= fmt.format("ToolBar.curDayText",data.curResult.getCaptureDate()) %>,
                <%= fmt.format("ToolBar.curYearText",data.curResult.getCaptureDate()) %>
              </span>
              <span style="color: #bbb; padding: 4px;">|</span>
              <a href="<%= staticPrefix %>"  
                 title="Find out more about the Stanford Wayback Machine"
                style="color: #ddd; text-decoration: none;">
                  Stanford Wayback Home
              </a>
              <span style="color: #bbb; padding: 4px;">|</span>
              <a href="#" id="su-wayback-machine-visibility-toggle"
                  style="color: #ddd; text-decoration: none;">
                  Hide overlay
              </a>
            </span>
          </div>

    <table style="border-collapse:collapse;margin:0;width:100%;
                  border-top: 1px solid #eee; 
                  border-bottom-left-radius: 9px; border-bottom-right-radius: 9px;
                  background-color: #f7f7f7;">
      <tbody>     
      <tr>
        <td style="padding:0!important;text-align:center;vertical-align:top;width:100%;">
          <table id="su-wayback-machine-toolbar-info" 
                 style="border-collapse:collapse;margin:0 auto;padding:0;width:570px;">
            <tbody>
              <tr>
                <td style="padding:3px 0;" colspan="2">
                  <form target="_top" method="get" action="<%= queryPrefix %>query" name="wmtb" id="wmtb"
                        style="margin:0!important;padding:0!important;">
                        <input type="text" name="<%= WaybackRequest.REQUEST_URL %>" id="wmtbURL" 
                                value="<%= searchUrlSafe %>" maxlength="256"
                                style="width:300px;font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;"/>
                        <input type="hidden" name="<%= WaybackRequest.REQUEST_TYPE %>" value="<%= WaybackRequest.REQUEST_REPLAY_QUERY %>">
                        <input type="hidden" name="<%= WaybackRequest.REQUEST_DATE %>" value="<%= data.curResult.getCaptureTimestamp() %>">
                        <input type="submit" value="Browse history" style="font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;margin-left:5px;"/>
                        <span id="wm_tb_options" style="display:block;"></span>
                  </form>
                </td>
                <td style="vertical-align:bottom;padding:5px 12px 0 0!important;" rowspan="2">
                  <table style="border-collapse:collapse;width:110px;color:#99a;font-family:'Helvetica','Lucida Grande','Arial',sans-serif;">
                    <tbody>			
                       <!-- NEXT/PREV MONTH NAV AND MONTH INDICATOR -->
                       <tr style="width:110px;height:16px;font-size:10px!important;">
                       	<td style="padding-right:9px;font-size:11px!important;font-weight:bold;text-transform:uppercase;
                                  text-align:right;white-space:nowrap;overflow:visible;" nowrap="nowrap">
                           <%
                           	if(data.monthPrevResult == null) {
                                   %>
                                   <%= fmt.format("ToolBar.noPrevMonthText",InteractiveToolBarData.addMonth(data.curResult.getCaptureDate(),-1)) %>
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.monthPrevResult) %>" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="<%= fmt.format("ToolBar.prevMonthTitle",data.monthPrevResult.getCaptureDate()) %>"><strong><%= fmt.format("ToolBar.prevMonthText",data.monthPrevResult.getCaptureDate()).toUpperCase() %></strong></a>
            		                <%
                           	}
                           %>
                           </td>
                           <td id="displayMonthEl" style="background:#000;color:#ff0;font-size:11px!important;font-weight:bold;text-transform:uppercase;width:34px;height:15px;padding-top:1px;text-align:center;" title="<%= fmt.format("ToolBar.curMonthTitle",data.curResult.getCaptureDate()) %>"><%= fmt.format("ToolBar.curMonthText",data.curResult.getCaptureDate()).toUpperCase() %></td>
            				<td style="padding-left:9px;font-size:11px!important;font-weight:bold;text-transform:uppercase;white-space:nowrap;overflow:visible;" nowrap="nowrap">
                           <%
                           	if(data.monthNextResult == null) {
                                   %>
                                   <%= fmt.format("ToolBar.noNextMonthText",InteractiveToolBarData.addMonth(data.curResult.getCaptureDate(),1)) %>
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.monthNextResult) %>" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="<%= fmt.format("ToolBar.nextMonthTitle",data.monthNextResult.getCaptureDate()) %>"><strong><%= fmt.format("ToolBar.nextMonthText",data.monthNextResult.getCaptureDate()).toUpperCase() %></strong></a>
            		                <%
                           	}
                           %>
                           </td>
                       </tr>
                       <!-- NEXT/PREV CAPTURE NAV AND DAY OF MONTH INDICATOR -->
                       <tr>
                           <td style="padding-right:9px;white-space:nowrap;overflow:visible;text-align:right!important;vertical-align:middle!important;" nowrap="nowrap">
                           <%
                           	if(data.prevResult == null) {
                                   %>
                                   <img src="<%= staticPrefix %>images/toolbar/wm_tb_prv_off.png" alt="Previous capture" width="14" height="16" border="0" />
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.prevResult) %>" title="<%= fmt.format("ToolBar.prevTitle",data.prevResult.getCaptureDate()) %>" style="background-color:transparent;border:none;"><img src="<%= staticPrefix %>images/toolbar/wm_tb_prv_on.png" alt="Previous capture" width="14" height="16" border="0" /></a>
            		                <%
                           	}
                           %>
                           </td>
                           <td id="displayDayEl" style="background:#000;color:#ff0;width:34px;height:24px;padding:2px 0 0 0;text-align:center;font-size:24px;font-weight: bold;" title="<%= fmt.format("ToolBar.curDayTitle",data.curResult.getCaptureDate()) %>"><%= fmt.format("ToolBar.curDayText",data.curResult.getCaptureDate()) %></td>
                           <td style="padding-left:9px;white-space:nowrap;overflow:visible;text-align:left!important;vertical-align:middle!important;" nowrap="nowrap">
                           <%
                           	if(data.nextResult == null) {
                                   %>
                                   <img src="<%= staticPrefix %>images/toolbar/wm_tb_nxt_off.png" alt="Next capture" width="14" height="16" border="0"/>
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.nextResult) %>" title="<%= fmt.format("ToolBar.nextTitle",data.nextResult.getCaptureDate()) %>" style="background-color:transparent;border:none;"><img src="<%= staticPrefix %>images/toolbar/wm_tb_nxt_on.png" alt="Next capture" width="14" height="16" border="0"/></a>
            		                <%
                           	}
                           %>
                         </td>
                       </tr>
                       <!-- NEXT/PREV YEAR NAV AND YEAR INDICATOR -->
                       <tr style="width:110px;height:13px;font-size:9px!important;">
                         <td style="padding-right:9px;font-size:11px!important;font-weight: bold;text-align:right;white-space:nowrap;overflow:visible;" nowrap="nowrap">
                           <%
                           	if(data.yearPrevResult == null) {
                                   %>
                                   <%= fmt.format("ToolBar.noPrevYearText",InteractiveToolBarData.addYear(data.curResult.getCaptureDate(),-1)) %>
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.yearPrevResult) %>" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="<%= fmt.format("ToolBar.prevYearTitle",data.yearPrevResult.getCaptureDate()) %>"><strong><%= fmt.format("ToolBar.prevYearText",data.yearPrevResult.getCaptureDate()) %></strong></a>
            		                <%
                           	}
                           %>
                           </td>
                           <td id="displayYearEl" style="background:#000;color:#ff0;font-size:11px!important;font-weight: bold;padding-top:1px;width:34px;height:13px;text-align:center;" title="<%= fmt.format("ToolBar.curYearTitle",data.curResult.getCaptureDate()) %>"><%= fmt.format("ToolBar.curYearText",data.curResult.getCaptureDate()) %></td>
                           <td style="padding-left:9px;font-size:11px!important;font-weight: bold;white-space:nowrap;overflow:visible;" nowrap="nowrap">
                           <%
                           	if(data.yearNextResult == null) {
                                   %>
                                   <%= fmt.format("ToolBar.noNextYearText",InteractiveToolBarData.addYear(data.curResult.getCaptureDate(),1)) %>
                                   <%
                           	} else {
            		                %>
            		                <a href="<%= data.makeReplayURL(data.yearNextResult) %>" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="<%= fmt.format("ToolBar.nextYearTitle",data.yearNextResult.getCaptureDate()) %>"><strong><%= fmt.format("ToolBar.nextYearText",data.yearNextResult.getCaptureDate()) %></strong></a>
            		                <%
                           	}
                           %>
                         </td>
                       </tr>
                    </tbody>
                  </table>

                </td>
              </tr>
              <tr>
               <td style="vertical-align:middle;padding:0!important;">
                 <a href="<%= starLink %>" 
                    style="color:#33f;font-size:11px;font-weight:bold;background-color:transparent;border:none;"
                    title="<%= fmt.format("ToolBar.numCapturesTitle") %>">
                    <strong><%= fmt.format("ToolBar.numCapturesText",data.getResultCount()) %></strong>
                 </a>
                 <div style="margin:0 10px!important;padding:0!important;
                       color:#666;font-size:11px; font-weight: bold;
                       padding-top:2px!important;white-space:nowrap;"
                     title="<%= fmt.format("ToolBar.captureRangeTitle") %>">
                     <%= fmt.format("ToolBar.captureRangeText",data.getFirstResultDate(),data.getLastResultDate()) %>
                 </div>
               </td>
               <td style="padding:0 20px!important;">
                 <a style="position:relative; white-space:nowrap; width:<%= imgWidth %>px;height:<%= imgHeight %>px;" href="" id="wm-graph-anchor">
                   <div id="wm-ipp-sparkline" style="position:relative; white-space:nowrap; width:<%= imgWidth %>px;height:<%= imgHeight %>px;background-color:#fff;cursor:pointer;border-right:1px solid #ccc;" title="<%= fmt.format("ToolBar.sparklineTitle") %>">
                    <img id="sparklineImgId" style="position:absolute; z-index:9012; top:0px; left:0px;"
                    	onmouseover="showTrackers('inline');" 
                    	onmouseout="showTrackers('none');"
                    	onmousemove="trackMouseMove(event,this)"
                    	alt="sparklines"
                    	width="<%= imgWidth %>"
                    	height="<%= imgHeight %>"
                    	border="0"
                    	src="<%= graphImgUrl %>"></img>
                    <img id="wbMouseTrackYearImg" 
                    	style="display:none; position:absolute; z-index:9010;"
                    	width="<%= yearWidth %>" 
                    	height="<%= imgHeight %>"
                    	border="0"
                    	src="<%= staticPrefix %>images/toolbar/transp-yellow-pixel.png"></img>
                    <img id="wbMouseTrackMonthImg"
                    	style="display:none; position:absolute; z-index:9011; " 
                    	width="<%= monthWidth %>"
                    	height="<%= imgHeight %>" 
                    	border="0"
                    	src="<%= staticPrefix %>images/toolbar/transp-red-pixel.png"></img>
                  </div>
                </a>
               </td>
             </tr>
           </tbody>
         </table>
       </td>
    </tr>
   </tbody>
  </table>

  </div> <!-- end #wm-ipp-inside -->
</div> <!-- end #wm-ipp -->

<script type="text/javascript">
 var wmDisclaimBanner = document.getElementById("wm-ipp");
 if(wmDisclaimBanner != null) {
   disclaimElement(wmDisclaimBanner);
 }
</script>
<!-- END WAYBACK TOOLBAR INSERT -->
