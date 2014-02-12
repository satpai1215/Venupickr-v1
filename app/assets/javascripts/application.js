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
    $('#venue-loading-gif').css('visibility', 'visible');
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
      $('.event-nav-link').removeClass('bold green');
      $(this).addClass('bold green');
      var index = $('.event-nav-link').index(this) + 1;

      $('.hide-box').hide();
      $('.hide-toggle-' + index).show();
  });

    $(document).on('keypress', '#email-dropdown', function(event) {
        if(event.keyCode == 13) {
            var emailinput = $("#email-dropdown").val();
            if(validateEmail(emailinput)) {
                addEmailToRecipientList(emailinput);
              } else {
                $("#notice").text("That email address is invalid.").fadeIn().delay(3000).fadeOut(1000);
              }
          $("#email-dropdown").val("");
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

  var wWidth = 0.9*$(window).width();
   var wHeight = 0.9*$(window).height();

   $("#createVenueForm").dialog({modal: true, autoOpen: false, minWidth: wWidth, show: 500, position: { my: "center top", at: "center top", of: "body" }});
   $("#createEventForm").dialog({modal: true, autoOpen: false, minWidth: wWidth, show: 500, position: { my: "center top", at: "center top", of: "body" }});
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
           $('#newCommentBtn').attr('disabled', false);    
      else
           $('#newCommentBtn').attr('disabled', true);   
  });

 //$('#suggestVenueLink, .edit-venue').bind('ajax:success', function () {
  //    $('#createVenueForm').dialog("open");
 // });


});