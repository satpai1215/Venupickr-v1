var voteCountArray = [];
var venueCount = 0;
var currentEventsArray = [];


function voteSort() {
    //console.log("poop");
    var $list = $("#venueList .listItem");

    $list.sort(function(a, b) {
        var aVotes = $(a).find(".voteCount").text();
        var bVotes = $(b).find(".voteCount").text();

        return parseInt(bVotes) - parseInt(aVotes);
    });
    $.each($list, function(index, li){
        $("#venueList ul").append(li);
    });
}

function overlay() {
    if( $("#userEntry").css("visibility") == "hidden") {
        $("#userEntry").css("visibility", "visible");
        $("#userEntryButton").css("visibility", "hidden");
    }
    else {
        $("#userEntry").css("visibility", "hidden");
        $("#userEntryButton").css("visibility", "visible");
    }
}

/********************
COUTNDOWN CREATION FUNCTIONS
 *********************/

function createCountdown(end_date, selector) {
    var dateString = parseDate(end_date);
    var end_timer = new Date(dateString);
    now = new Date();
    if(end_timer - now > 0) {
        var t = setInterval(function() {updateCountdown(end_timer, selector)} , 1000);
    }
}


//creates countdown timers in events#index view for each event
function createTimersinView()
{
	var eventDate = [];
	for (var i = 0; i < gon.numEvents; i++) { 
		var dateFromView = $("#eventIndexTimer" + i).data("date");
        //console.log(dateFromView);
		var dateString = parseDate(dateFromView)
		eventDate.push(new Date(dateString));
	}
	for(var i=0; i < eventDate.length; i++) {
		var x= eventDate[i];
		var now = new Date();
		if (eventDate[i] - now > 0) {
	  		setInterval(function(x, i) {return function() {updateCountdown(x, "#eventIndexTimer" + i)}}(x, i) , 1000);
	  	}

	}
}

//parses date string object returned from rails events#index view
function parseDate(date) {
	var dateStrings = date.split(" ");

	//dateStrings[0] = "2013-01-05", dateStrings[1] = "16:00:00", for example
	return dateStrings[0] + " " + dateStrings [1];
}


//updates countdown timer for upcoming events
function updateCountdown(d, selector) {
    var currentDate = new Date();
    if (d - currentDate <=0) {
        $(selector).html("Time's Up!");
    }
    else {

        var timeMS = Math.abs(d - currentDate);
        var seconds = Math.round(timeMS/1000);
        var minutes = Math.floor(seconds/60);
        seconds %= 60;
        var hours = Math.floor(minutes/60);
        minutes %= 60;
        var days = Math.floor(hours/24);
        hours %= 24;

        $(selector).html(days + ((days === 1) ? " Day": " Days") + " " + numChecker(hours) + ":" + numChecker(minutes) + ":" + numChecker(seconds));
    }
}

//converts numbers to two digit strings for countdown timer
function numChecker(num) {
    if(num <10){
        return "0" + num;
    }
    return num;
}
/********************
END COUTNDOWN CREATION FUNCTIONS
 *********************/


/********************
 $(document).ready() function
 *********************/
$(function() {

	   //var dateFromIndex = $("#eventIndexTimer").data("date");
	   //var dateIndex = $(".eventIndexTimer").data("index");
	   //var eventDate = new Date(dateFromIndex);
    	//var t = setInterval(function() {updateCountdown(eventDate, dateIndex)} , 1000);

});