<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"
%><%@ page import="java.util.Date"
%><%@ page import="java.util.Map"
%><%@ page import="java.util.Iterator"
%><%@ page import="java.lang.StringBuffer"
%><%@ page import="org.archive.wayback.archivalurl.ArchivalUrlDateRedirectReplayRenderer"
%><%@ page import="org.archive.wayback.ResultURIConverter"
%><%@ page import="org.archive.wayback.archivalurl.ArchivalUrl"
%><%@ page import="org.archive.wayback.core.UIResults"
%><%@ page import="org.archive.wayback.core.WaybackRequest"
%><%@ page import="org.archive.wayback.core.CaptureSearchResult"
%><%@ page import="org.archive.wayback.util.StringFormatter"
%><%@ page import="org.archive.wayback.util.url.UrlOperations"
%><%
UIResults results = UIResults.extractReplay(request);

WaybackRequest wbr = results.getWbRequest();
StringFormatter fmt = wbr.getFormatter();
CaptureSearchResult cResult = results.getResult();
ResultURIConverter uric = results.getURIConverter();

String sourceUrl = cResult.getOriginalUrl();
String targetUrl = cResult.getRedirectUrl();
String captureTS = cResult.getCaptureTimestamp();
Date captureDate = cResult.getCaptureDate();
if(targetUrl.equals("-")) {
	Map<String,String> headers = results.getResource().getHttpHeaders();
	Iterator<String> headerNameItr = headers.keySet().iterator();
	while(headerNameItr.hasNext()) {
	       String name = headerNameItr.next();
	       if(name.toUpperCase().equals("LOCATION")) {
	    	    targetUrl = headers.get(name);
	            // by the spec, these should be absolute already, but just in case:
	            targetUrl = UrlOperations.resolveUrl(sourceUrl, targetUrl);
	    	    
	    	    
	       }
	}
}
// TODO: Handle replay if we still don't have a redirect..
ArchivalUrl aUrl = new ArchivalUrl(wbr);
String dateSpec = aUrl.getDateSpec(captureTS);

String targetReplayUrl = uric.makeReplayURI(dateSpec,targetUrl);

String safeSource = fmt.escapeHtml(sourceUrl);
String safeTarget = fmt.escapeHtml(targetUrl);
String safeTargetJS = fmt.escapeJavaScript(targetUrl);
String safeTargetReplayUrl = fmt.escapeHtml(targetReplayUrl);
String safeTargetReplayUrlJS = fmt.escapeJavaScript(targetReplayUrl);

String prettyDate = fmt.format("MetaReplay.captureDateDisplay",captureDate);
int secs = 5;

%>
    <jsp:include page="/WEB-INF/template/UI-header.jsp" flush="true" />

        <div id="positionHome">
            <div id="error" style="padding-left:10px;">
	<script type="text/javascript">
	function go() {
		document.location.href = "<%= safeTargetReplayUrlJS %>";
	}
	window.setTimeout("go()",<%= secs * 1000 %>);
	</script>
			<h3>Loading...</h3>
		<p >The requested URI: <span class="font"><%= safeSource %> </span> at <%= prettyDate %> got an HTTP 302 response at crawl time. Wayback will redirect you in 5 sec to ...</p>
		<p ><%= safeTarget %></p>

        <p style="font-size:small;" ><br/>Do you have problems with redirection? Use this <a href="<%= safeTargetReplayUrl %>">direct link</a>.</p>
            </div>
            </section>
            <div id="errorBorder" style="padding-bottom: 130px"></div>

        <jsp:include page="/WEB-INF/template/UI-footer.jsp" flush="true" />