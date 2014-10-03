<jsp:include page="/WEB-INF/template/UI-header.jsp" flush="true" />

<!-- Main page content -->
<div id="main-container" class="container">

  <!-- Row of thumbnails/links to featured archived sites -->
  <div class="row featured-sites">
    <div id="content" class="col-sm-12">
      <div class="row">
        <div class="col-sm-12">
          <h2>Featured archived sites</h2>
        </div>
      </div>

      <div class="row">
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/20140909184942/http://stanford.edu/">
              <img alt="Stanford University archived homepage" src="/images/featured_sites/stanford-2007.png">
              <div class="caption">
                <h3>Stanford University Homepage: 2007</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/*/http://stanford.edu">
              <img alt="Stanford Arts archived homepage" src="/images/featured_sites/stanford-arts-1997.png">
              <div class="caption">
                <h3>Stanford Arts: 1997</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/20140909184942/http://stanford.edu/">
              <img alt="Google archived homepage" src="/images/featured_sites/nytimes-2002.png">
              <div class="caption">
                <h3>New York Times: 2002</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/http://stanford.edu/*">
              <img alt="Stanford University Libraries archived homepage" src="/images/featured_sites/sul-2005.png">
              <div class="caption">
                <h3>Stanford University Libraries: 2005</h3>
              </div>
            </a>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- Temporary - row of thumbnails/links to pages under development -->
  <div class="row featured-sites">
    <div id="content" class="col-sm-12">
      <div class="row">
        <div class="col-sm-12">
          <h2>Wayback page types</h2>
        </div>
      </div>

      <div class="row">
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/20140909184942/http://stanford.edu/">
              <img alt="Temp" src="/images/temp/temp-archived-page.png">
              <div class="caption">
                <h3>Archived Page</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/*/http://stanford.edu/*">
              <img alt="Temp" src="/images/temp/temp-url-results.png">
              <div class="caption">
                <h3>URL Results</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/*/http://stanford.edu/">
              <img alt="Temp" src="/images/temp/temp-calendar-results.png">
              <div class="caption">
                <h3>Calendar Results</h3>
              </div>
            </a>
          </div>
        </div>
        <div class="col-sm-3">
          <div class="thumbnail">
            <a href="/wayback/http://stanford.edu/error">
              <img alt="Temp" src="/images/temp/temp-error.png">
              <div class="caption">
                <h3>Error Page</h3>
              </div>
            </a>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- Closing tags below close tags opened in UI_header.jsp -->
  </div> <!-- #su-content end -->
</div> <!-- #su-wrap end -->

<jsp:include page="/WEB-INF/template/UI-footer.jsp" flush="true" />
