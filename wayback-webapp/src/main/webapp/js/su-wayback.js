$(document).ready(function(){

  $('#contact_us_link, .error-page-feedback').click(function() {
    $(".report-problem")[0].reset();
    $('#report-problem-form').slideToggle('slow');
    return false;
  });

  $('#report-problem-form .cancel-link').click(function() {
    $(".report-problem")[0].reset();
    $('#report-problem-form').slideUp('fast');
    return false;
  });

});
