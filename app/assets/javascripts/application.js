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
//= require jquery-ui-1.10.3.custom.min.js
//= require jquery.timepicker.min.js
//= require_tree .


$(document).ready(function() {
  $(document).ajaxError(function (e, xhr, settings) {
       // if (xhr.status == 401) {
          $('#notice').html(xhr.responseText);
       // }
    });

   $('.voteButton').ajaxSuccess(function() {  
      votesort();  
    });

  $(document).on('click', '#guest_form_selectall_btn', function(event) {
    $('.guest_checkbox').prop('checked', true);
  });
  $(document).on('click', '#guest_form_deselectall_btn', function(event) {
    $('.guest_checkbox').prop('checked', false);
  });

  $(document).on('click', '#invite_guest_form_submit', function(event) {
    $('#event-loading-gif').css('visibility', 'visible');
    $('#invite_guest_form_submit').hide();
  });
  $(document).on('click', '#eventSubmitButton', function(event) {
    $('#event-loading-gif').css('visibility', 'visible');
    $('#eventSubmitButton').hide();
  });
  $(document).on('click', '#venueSubmitButton', function(event) {
    $('#event-loading-gif').css('visibility', 'visible');
    $('#venueSubmitButton').hide();
  });
  
  $(document).on('click', '#rsvpButton-yes', function(event) {
    $(this).addClass('green').css('background', '#d6e6e6');
    $("#rsvpButton-no").removeClass('red').css('background', '#f5f5f5');;
  });
  $(document).on('click', '#rsvpButton-no', function(event) {
    $(this).addClass('red').css('background', '#eebfda');;
    $("#rsvpButton-yes").removeClass('green').css('background', '#f5f5f5');;
  });

  $(document).on('click', '.appActions', function(event) {
    var prev_index = $('.appActions').index('.selected');
    var index = $('.appActions').index(this);
    console.log(prev_index + " and " + index);


    $('.appActions').removeClass('selected');
    $(this).toggleClass('selected');
    
    $('.appActionsInfo').removeClass('block');
    $('.appActionsInfo:eq(' + prev_index + ')').hide('slide', 'left');
    $('.appActionsInfo:eq(' + index + ')').toggleClass('block');
    $('.appActionsInfo:eq(' + index + ')').show('slide', 'right');
  
  });


   $('#user_notification_emails').change(function() {  
      if (!$(this).prop('checked')) {
        window.alert("Are you sure?  You will no longer get reminders about events and voting.");
      }
    }); 

   $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: 400, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
   $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: 500, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
   $("#inviteGuestsForm").dialog({modal: true, autoOpen: false, width: 500, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
   //$(".voteList").dialog({modal: true, autoOpen: false, minWidth: 500, show: 500, position: { my: "center top", at: "center top", of: "#main" }});

   $(".voteCount").hover( 
      function () {
        $(this).siblings("ol.voteList").fadeIn();
      },
      function () {
        $(this).siblings("ol.voteList").fadeOut();
      }
    );

   $('#enterCommentsField').keyup(function(){
      var str = $('#enterCommentsField').val();
      if(!(!str || /^\s*$/.test(str))) 
           $('#postCommentButton').attr('disabled', false);    
      else
           $('#postCommentButton').attr('disabled', true);   
  });

 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //    $('#createVenueForm').dialog("open");
 // });


});