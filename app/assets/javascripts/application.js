// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require autocomplete-rails
//= require jquery.ui.dialog
//= require_tree


$(function() {
	$(document).ajaxError(function (e, xhr, settings) {
       // if (xhr.status == 401) {
          $('#notice').html(xhr.responseText);
       // }
    });

 $('.voteButton').bind('ajax:success', function() {  
    votesort();  
	});


$('#eventSubmitButton').click(function(){
  $('#eventSubmitButton').css('visibility', 'hidden');
});

/*$('#venue_name').bind('ajax:beforeSend', function(){
  $('#venue-loading-gif').show();
});*/

 $('#user_notification_emails').change(function() {  
    if (!$(this).prop('checked')) {
      window.alert("Are you sure?  You will no longer get reminders about events and voting.");
    }
  }); 

 $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: 400, show: 500});
 $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: 500, show: 500});
 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //  	$('#createVenueForm').dialog("open");
 //	});


});