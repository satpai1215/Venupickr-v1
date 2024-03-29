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
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.3.custom.min.js
//= require jquery.timepicker.min.js
//= require_tree .


$(document).ready(function() {
  $(document).ajaxError(function (e, xhr, settings) {
       // if (xhr.status == 401) {
         // $('#notice').html(xhr.responseText);
       // }
    });

   $('.voteButton').ajaxSuccess(function() {  
      votesort();  
    });

   $(document).on('click', "#notice", function(event) {
    //$(this).fadeOut(500);
    $(this).text("");
    //$(this).fadeIn();
   });
    $(document).on('click', "#alert", function(event) {
    $(this).fadeOut(500);
   });

  //EDGE CASE: user choosed yelp suggested venue, but decides to change it to a non-yelp place.
  // need to reset venue_url so it doesnt link to wrong venue
  $(document).on('change', '#venue_address', function(event) {
      $('#venue_url').val('');
  });
    $(document).on('change', '#venue_name', function(event) {
      $('#venue_url').val('');
  });



  $(document).on('click', '#new-guest-form-submit', function(event) {
    //$('.loading-gif').css('visibility', 'visible');
    $('#form-submit-filler-text').show();
    $('#new-guest-form-submit').hide();
  });
  $(document).on('click', '#eventSubmitButton', function(event) {
    $('.loading-gif').css('visibility', 'visible');
    $('#eventSubmitButton').hide();
  });
  $(document).on('click', '#venueSubmitButton', function(event) {
    $('.loading-gif').css('visibility', 'visible');
    $('#venueSubmitButton').hide();
  });
  $(document).on('keypress', '#event_name, #venue_name, #venue_comments', function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
  
;  $(document).on('click', '#rsvpButton-yes', function(event) {
    $(this).addClass('green').css('background', '#d6e6e6');
    $("#rsvpButton-no").removeClass('red').css('background', '#f5f5f5');;
  });
  $(document).on('click', '#rsvpButton-no', function(event) {
    $(this).addClass('red').css('background', '#eebfda');;
    $("#rsvpButton-yes").removeClass('green').css('background', '#f5f5f5');;
  });

  $(document).on('click', '.appActions', function(event) {

    if($(this).hasClass('selected')) {
      $(this).removeClass('selected').siblings('.appActionsInfo').slideUp();
    } else {
      $('.selected').removeClass('selected').siblings('.appActionsInfo').slideUp();
      $(this).toggleClass('selected');
      $(this).siblings('.appActionsInfo').slideDown();
    }
  
  });

    $(document).on('click', '.event-nav-link', function(event) {
      event.preventDefault();
      displayEventShowTab($('.event-nav-link').index(this) + 1)
  });


  $(document).on('click', "#addEmailBtn", function(event) {
      event.preventDefault();
      addEmailAction();
  });


  $(document).on('keypress', '#email-dropdown', function(event) {
      if(event.keyCode == 13) {
          addEmailAction();
      }
  });

  $(document).on('click', '.remove-email', function(event) {
    $(this).parent().remove();
  });

   $('#user_notification_emails').change(function() {  
      if (!$(this).prop('checked')) {
        window.alert("Are you sure?  You will no longer get reminders about events and voting.");
      }
    }); 


    var wWidth = $(window).width();
    var formWidth = 0.95 * wWidth;
    var anchor = "body";
    if(wWidth > 600) {
      formWidth = 0.5 * wWidth;
      anchor = "#nav_body";
    }

   $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: formWidth, show: 500, position: { my: "center top", at: "center top", of: anchor }});
   $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: formWidth, show: 500, position: { my: "center top", at: "center top", of: anchor }});
   $("#inviteGuestsForm").dialog({modal: true, autoOpen: false, minWidth: formWidth, show: 500, position: { my: "center top", at: "center top", of: "#main" }});
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
           $('#newCommentBtn').attr('disabled', false);    
      else
           $('#newCommentBtn').attr('disabled', true);   
  });

 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //    $('#createVenueForm').dialog("open");
 // });


});