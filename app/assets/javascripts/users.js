
 $('#user_notification_emails').change(function() {  
    if (!$(this).prop('checked')) {
      window.alert("Are you sure?  You will no longer get reminders about events and voting.");
    }
  }); 