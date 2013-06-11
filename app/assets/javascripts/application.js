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

 $('.voteButton').ajaxSuccess(function() {  
    votesort();  
	});


$(document).on('click', '#eventSubmitButton', function(event) {
  $('#event-loading-gif').css('visibility', 'visible');
  $('#eventSubmitButton').hide();
});

$(document).on('click', '.appActions', function(event) {
  $('.appActions').removeClass('selected');
  $(this).toggleClass('selected');
  var index = $('.appActions').index(this);
  $('.appActionsInfo').removeClass('block');
  $('.appActionsInfo:eq(' + index + ')').toggleClass('block');
});

 $('#user_notification_emails').change(function() {  
    if (!$(this).prop('checked')) {
      window.alert("Are you sure?  You will no longer get reminders about events and voting.");
    }
  }); 

 $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: 400, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
 $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: 500, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //  	$('#createVenueForm').dialog("open");
 //	});


});