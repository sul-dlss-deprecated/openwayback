<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="org.archive.wayback.core.WaybackRequest" %>
<%@ page import="org.archive.wayback.core.UIResults" %>
<%@ page import="org.archive.wayback.util.StringFormatter" %>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"%>
<%
UIResults results = UIResults.getGeneric(request);
WaybackRequest wbRequest = results.getWbRequest();
StringFormatter fmt = wbRequest.getFormatter();

String staticPrefix = results.getStaticPrefix();
String queryPrefix = results.getQueryPrefix();
String replayPrefix = results.getReplayPrefix();

%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Stanford Web Archive Portal</title>

   <!-- Bootstrap sytles -->
    <link href="<%= staticPrefix %>css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Two stylesheets below are for Stanford Identity footer -->
    <link href="https://www.stanford.edu/su-identity/css/su-identity.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700' rel='stylesheet' type='text/css'>
    <!-- Original Wayback Machine CSS -->
    <link href="<%= staticPrefix %>css/styles.css" media="all" rel="stylesheet" type="text/css" />
    <!-- Customized Stanford Wayback Machine CSS -->
    <link href="<%= staticPrefix %>css/su-wayback.css" media="all" rel="stylesheet" type="text/css" />
    
    <script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	
	  ga('create', 'UA-7219229-29', 'auto');
	  ga('send', 'pageview');
	</script>
  </head>

  <body onload="" class="">
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="<%= staticPrefix %>js/bootstrap.min.js"></script>
    <!-- Stanford Wayback specific JS -->
    <script src="<%= staticPrefix %>js/su-wayback.js"></script>

    <div id="su-wrap"> <!-- #su-wrap start -->
      <div id="su-content"> <!-- #su-content start -->

        <!-- Brandbar snippet start -->
        <div id="brandbar">
          <div class="container">
            <a href="http://library.stanford.edu/">
              <img alt="Stanford University Libraries" src="<%= staticPrefix %>images/SUL-Logo-white-text-h25.png">
            </a>
            <span id="report-problem">
          	  <a href="mailto:sul-was-support@lists.stanford.edu" >Feedback</a>
          	</span>
          </div>
        </div>
        <!-- Brandbar snippet end -->

        <!-- Report a problem form -->
        <div id="report-problem-form" class="">
          <div class="container">
            <div class="row">
              <div class="col-sm-8 col-sm-offset-2 col-xs-12 col-xs-offset-0">
                <h2>Contact Us</h2>
              </div>
            </div>
          </div>

          <div class="container">
            <div class="row">
              <div class="col-sm-10 col-sm-offset-2">
                <form accept-charset="UTF-8" action="/contact" class="form-horizontal report-problem" data-remote="true" method="post">

                	<div id="contact-us-errors" class="contact-us-errors alert alert-error hidden"></div>

                	<input id="from" name="from" type="hidden" value="/galleries/my-fancy-gallery-with-a-pretty-long-title">
                	<input id="auto_response" name="auto_response" type="hidden" value="true">
                	<input id="loadtime" name="loadtime" type="hidden" value="2014-09-15 16:22:47 -0700">

                		<div class="form-group">
                		  <label class="control-label col-xs-12 col-sm-3 col-md-2" for="subject">Subject</label>
                		  <div class="col-xs-8 col-sm-6 col-md-5">
                		    <select class="col-md-3 form-control" id="subject" name="subject"><option value="default">Select a topic...</option>
                <option value="metadata">Corrections to content</option>
                <option value="error">Problem with the website</option>
                <option value="other">Other questions</option></select>
                		  </div>
                		</div>
	
                	<div class="form-group">
                	  <label class="control-label col-xs-12 col-sm-3 col-md-2" for="message">Message</label>
                	  <div class="col-xs-12 col-sm-9 col-md-10">
                	    <textarea class="form-control" id="message" name="message" placeholder="Please describe your question or problem." rows="10"></textarea>
                	  </div>
                	</div>

                	<div class="form-group">
                	  <label class="control-label col-xs-12 col-sm-3 col-md-2" for="name">Your name</label>
                	  <div class="col-xs-8 col-sm-6 col-md-5">
                	    <input class="form-control" id="fullname" name="fullname" placeholder="Your name" type="text" value="">
                	  </div>
                	</div>

                	<div class="form-group">
                	  <label class="control-label col-xs-12 col-sm-3 col-md-2" for="email">Your email</label>
                	  <div class="col-xs-8 col-sm-6 col-md-5">
                	    <input class="form-control" id="email" name="email" placeholder="Email address" type="text" value="">
                	  </div>
                	</div>

                	<div class="form-group hidden">
                	  <label class="control-label col-xs-12 col-sm-3 col-md-2" for="email">Leave blank</label>
                	  <div class="col-xs-8 col-sm-6 col-md-5">
                	    <input class="form-control" id="email_confirm" name="email_confirm" placeholder="Please leave this field blank - it is used to prevent spam submissions" type="text" value="">
                	  </div>
                	</div>

                	<div class="form-group">
                	  <div class="col-sm-offset-3 col-sm-6 col-md-offset-2">
                	    <input class="btn btn-default" name="commit" type="submit" value="Send">
                	    <a href="/" class="cancel-link">Cancel</a>
                	  </div>
                	</div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <!-- Site masthead: application title and subtitle -->
        <div class="masthead">
          <div class="container">
            
            <div class="site-header-content">
              <h1><a href="<%= staticPrefix %>">Stanford Web Archive Portal</a>
                <!-- Toggle icon used to show navbar, which is hidden when 
                    viewport is less than  768px wide -->
                <div class="navbar navbar-default">
                  <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#wayback-navbar">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                    </button>
                  </div>  
                </div> <!-- end toggle icon -->
              </h1>
              <h2 class="hidden-xs">
                A searchable collection of websites archived by Stanford University
              </h2>
            </div>
          </div>
        </div>

        <!-- Search bar below masthead -->
        <nav class="navbar navbar-default search-bar" role="navigation">
          <div class="container">
            <!-- Search bar content for toggling; content is visible when
                 viewport is at least 768px wide, hidden when less than 768px -->
            <div class="collapse navbar-collapse" id="wayback-navbar">
              <form class="navbar-form center-block clearfix" action="<%= queryPrefix %>query" method="get" role="search">
                <div class="form-group">
                  <div class="input-group">
                    <span class="input-group-addon">http://</span>
                    <input type="hidden" name="<%= WaybackRequest.REQUEST_TYPE %>" value="<%= WaybackRequest.REQUEST_CAPTURE_QUERY %>">
                    <input type="text" name="<%= WaybackRequest.REQUEST_URL %>" class="form-control input-sm search-url" size="30" value="">
                  </div>
                </div>
                <div class="form-group">
                  <select name="<%= WaybackRequest.REQUEST_DATE %>" class="form-control input-sm">
        						<option value="" selected="">Any year</option>
        						<option>2010</option>
        						<option>2009</option>
        						<option>2008</option>
        						<option>2007</option>
        						<option>2006</option>
        						<option>2005</option>
        						<option>2004</option>
        						<option>2003</option>
        						<option>2002</option>
        						<option>2001</option>
        						<option>2000</option>
        						<option>1999</option>
        						<option>1998</option>
        						<option>1997</option>
        						<option>1996</option>
        					</select>
                </div>
                <button type="submit" class="btn btn-default btn-sm">Browse history</button>
              </form>
              <!-- <div class="form-group advanced-search">
                <a href="<%= staticPrefix %>advanced_search.jsp">
                  Advanced Search
                </a>
              </div> -->
            </div><!-- /.navbar-collapse -->
          </div>
        </nav>

