<%@   page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"
%><%@ page import="java.util.Iterator"
%><%@ page import="java.util.ArrayList"
%><%@ page import="java.util.Date"
%><%@ page import="org.archive.wayback.ResultURIConverter"
%><%@ page import="org.archive.wayback.WaybackConstants"
%><%@ page import="org.archive.wayback.core.UIResults"
%><%@ page import="org.archive.wayback.core.UrlSearchResult"
%><%@ page import="org.archive.wayback.core.UrlSearchResults"
%><%@ page import="org.archive.wayback.core.WaybackRequest"
%><%@ page import="org.archive.wayback.util.StringFormatter"
%>

<jsp:include page="/WEB-INF/template/UI-header.jsp" flush="true" />

<%
UIResults results = UIResults.extractUrlQuery(request);
WaybackRequest wbRequest = results.getWbRequest();
UrlSearchResults uResults = results.getUrlResults();
ResultURIConverter uriConverter = results.getURIConverter();
StringFormatter fmt = wbRequest.getFormatter();

String searchString = wbRequest.getRequestUrl();
String staticPrefix = results.getStaticPrefix();
String queryPrefix = results.getQueryPrefix();
String replayPrefix = results.getReplayPrefix();

Date searchStartDate = wbRequest.getStartDate();
Date searchEndDate = wbRequest.getEndDate();

long firstResult = uResults.getFirstReturned();
long lastResult = uResults.getReturnedCount() + firstResult;

long totalCaptures = uResults.getMatchingCount();

%>
<!-- DataTables CSS -->
<link rel="stylesheet" type="text/css"
  href="//cdn.datatables.net/plug-ins/725b2a2115b/integration/bootstrap/3/dataTables.bootstrap.css">
  
<!-- DataTables JS -->
<script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.2/js/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf8" 
  src="//cdn.datatables.net/plug-ins/725b2a2115b/integration/bootstrap/3/dataTables.bootstrap.js"></script>

<script type="text/javascript">
  $(document).ready( function () {
      $('#urlResultsTable').DataTable({
        "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "iDisplayLength": 25
    });
  } );
</script>

<!-- Main page content -->
<div id="main-container" class="container url-results">
  <div class="row">
    <div id="content" class="col-sm-12">
      <h2>
        <span class="result-count"><%= totalCaptures %></span>
        URLs have been captured for this domain
      </h2>

    <table id="urlResultsTable" class="table table-striped table-bordered">
      <thead>
        <tr>
          <th class="url">URL<span></span></th>
          <th>From<span></span></th>
          <th>To<span></span></th>
          <th>Captures<span></span></th>
          <th>Duplicates<span></span></th>
          <th>Uniques<span></span></th>
        </tr>
      </thead>
      <tbody>
<%
Iterator<UrlSearchResult> itr = uResults.iterator();
while(itr.hasNext()) {
  UrlSearchResult result = itr.next();

  String urlKey = result.getUrlKey();
  String originalUrl = result.getOriginalUrl();
  String firstDateTSss = result.getFirstCaptureTimestamp();
  String lastDateTSss = result.getLastCaptureTimestamp();
  long numCaptures = result.getNumCaptures();
  long numVersions = result.getNumVersions();
  long numDupes = result.getNumCaptures() - result.getNumVersions();

  Date firstDate = result.getFirstCaptureDate();
  Date lastDate = result.getLastCaptureDate();
  
  if(numCaptures == 1) {
	  String ts = result.getFirstCaptureTimestamp();
	  String anchor = uriConverter.makeReplayURI(ts,originalUrl);
    %>
      <tr>
        <td class="url">
          <a onclick="SetAnchorDate('<%= ts %>');" href="<%= anchor %>"><%= urlKey %></a>
        </td>
        <td class="dateFrom"><%= fmt.format("PathPrefixQuery.captureDate",firstDate) %></td>
        <td class="dateTo"><%= fmt.format("PathPrefixQuery.captureDate",lastDate) %></td>
        <td class="captures"><%= numCaptures %></td>
        <td class="dupes"><%= numDupes %></td>
        <td class="uniques"><%= numVersions %></td>
      </tr>
    <!--
    <span class="mainSearchText">
      <%= fmt.format("PathPrefixQuery.versionCount",numVersions) %>
    </span>
    <br/>
    <span class="mainSearchText">
      <%= fmt.format("PathPrefixQuery.singleCaptureDate",firstDate) %>
    </span>
    -->
    <%
    
  } else {
    String anchor = results.makeCaptureQueryUrl(originalUrl);
    %>
      <tr>
        <td class="url">
          <a href="<%= anchor %>"><%= urlKey %></a>
        </td>
        <td class="dateFrom"><%= fmt.format("PathPrefixQuery.captureDate",firstDate) %></td>
        <td class="dateTo"><%= fmt.format("PathPrefixQuery.captureDate",lastDate) %></td>
        <td class="captures"><%= numCaptures %></td>
        <td class="dupes"><%= numDupes %></td>
        <td class="uniques"><%= numVersions %></td>
      </tr>
    <!--
    <a href="<%= anchor %>">
      <%= urlKey %>
    </a>
    <span class="mainSearchText">
      <%= fmt.format("PathPrefixQuery.versionCount",numVersions) %>
    </span>
    <br/>
    <span class="mainSearchText">
      <%= fmt.format("PathPrefixQuery.multiCaptureDate",numCaptures,firstDate,lastDate) %>
    </span>
    -->
    <%    
  }
  %>
  <%
}

  // show page indicators:
  int curPage = uResults.getCurPageNum();
  if(curPage > uResults.getNumPages()) {
    %>
    <a href="<%= results.urlForPage(1) %>">First results</a>
    <%
  } else if(uResults.getNumPages() > 1) {
    %>

    <%
    for(int i = 1; i <= uResults.getNumPages(); i++) {
      if(i == curPage) {
        %>
        <b><%= i %></b>
        <%    
      } else {
        %>
        <a href="<%= results.urlForPage(i) %>"><%= i %></a>
        <%
      }
    }
  }
  %>
        </tbody>
      </table>

    </div>
  </div>
</div>

<!-- Closing tags below close tags opened in UI_header.jsp -->
      </div> <!-- #su-content end -->
    </div> <!-- #su-wrap end -->
  
<jsp:include page="/WEB-INF/template/UI-footer.jsp" flush="true" />
