$('.delete-venue').bind('ajax:success', function() {  
    $(this).closest('li').slideUp();  
	}); 
