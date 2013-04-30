var voteCountArray = [];
var venueCount = 0;
var currentEventsArray = [];

/********************
YELP API AJAX REQUEST FUNCTIONS
 *********************/

function AC(){
$( "#venue_name" ).autocomplete({
    source: function(request, response) {
          yelpRequest(request, response);
    },
    autoFocus: true,
    minLength: 3,
    delay: 500,
    select: function( event, ui ) {
        var addy = ""
        ui.item.address.forEach(function(line) {
            addy += line + "\n";
        });
        $("#venue_address").val(addy);
        $("#venue_url").val(ui.item.url)

    },
    open: function() {
        $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
    },
    close: function() {
        $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
    }
});
}


function yelpRequest(request, response) {
    console.log(request.term);
    var auth = {
        //
        // Update with your auth tokens.
        //
        consumerKey: "xIeBBXL6bTqP5MDheNuehw",
        consumerSecret: "843wPzWYIVym8o9MG4X5jwsMt9U",
        accessToken: "NQQE9MaKFgSgzrzTKWKLSfVIaWPxYfa_",
        // This example is a proof of concept, for how to use the Yelp v2 API with javascript.
        // You wouldn't actually want to expose your access token secret like this in a real application.
        accessTokenSecret: "VVkDuwQTQPiLxW0yMJX_K4OSRqc",
        serviceProvider: {
            signatureMethod: "HMAC-SHA1"
        }
    };
    //var term = "soda popinski"
    var near = 'San+Francisco';
    var accessor = {
        consumerSecret: auth.consumerSecret,
        tokenSecret: auth.accessTokenSecret
    };

    parameters = [];
    parameters.push(['term', request.term]);
    parameters.push(['location', near]);
    parameters.push(['callback', 'cb']);
    parameters.push(['oauth_consumer_key', auth.consumerKey]);
    parameters.push(['oauth_consumer_secret', auth.consumerSecret]);
    parameters.push(['oauth_token', auth.accessToken]);
    parameters.push(['oauth_signature_method', 'HMAC-SHA1']);
    parameters.push(['featureClass', 'P']);
    parameters.push(['style', 'full']);
    parameters.push(['maxRows', 12]);
    parameters.push(['name_startsWith', request.term]);

    var message = {
        'action': 'http://api.yelp.com/v2/search',
        'method': 'GET',
        'parameters': parameters
    };

    OAuth.setTimestampAndNonce(message);
    OAuth.SignatureMethod.sign(message, accessor);

    var parameterMap = OAuth.getParameterMap(message.parameters);
    parameterMap.oauth_signature = OAuth.percentEncode(parameterMap.oauth_signature)

    $.ajax({
        'url': message.action,
        'data': parameterMap,
        'cache': true,
        'dataType': 'jsonp',
        'success' : function(data) {
            console.log(data.businesses);
            //var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
            var matcher = new RegExp("^" + request.term, "i");
            response($.map(data.businesses, function(item){
                if (matcher.test(item.name)) {
                  return {
                        label: (item.location.neighborhoods == null ? 
                            item.name : item.name + " (" + item.location.neighborhoods[0] + ")"),
                        value: item.name,
                        address: item.location.display_address,
                        //neighborhood: item.location.neighborhood[0],
                        url: item.url
                    }
                }
            }));
        }});
            /*var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
            response( $.grep( data.businesses, function( item ){
                    return (matcher.test(item.name))
            }*/
}
/********************
END YELP API AJAX REQUEST FUNCTIONS
 *********************/



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
        console.log(dateFromView);
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