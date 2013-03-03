var voteCountArray = [];
var venueCount = 0;
var currentEventsArray = [];

function AC(){
$( "#venueName" ).autocomplete({
    source: function(request, response) {
        yelpRequest(request, response)
    },
    autoFocus: true,
    minLength: 2,
    delay: 500,
    select: function( event, ui ) {
        ui.item.address.forEach(function(line) {
            $("#venueInfo").append(line + "\n");
        });

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

    var auth = {
        //
        // Update with your auth tokens.
        //
        consumerKey: "xIeBBXL6bTqP5MDheNuehw",
        consumerSecret: "843wPzWYIVym8o9MG4X5jwsMt9U",
        accessToken: "5C_yXJuWHwqk1nK1Vbmm8-V8F6plW8Jf",
        // This example is a proof of concept, for how to use the Yelp v2 API with javascript.
        // You wouldn't actually want to expose your access token secret like this in a real application.
        accessTokenSecret: "l8fc-v7JWbKrdck9Kw3PBW6vOmI",
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
            response($.map(data.businesses.slice(0, 10), function(item){
                    return {
                        label: item.name,
                        value: item.name,
                        address: item.location.display_address
                    }}

            /*var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
            response( $.grep( data.businesses, function( item ){
                    return (matcher.test(item.name))
            }*/

            ));

        }
        /*'success': function(data, textStats, XMLHttpRequest) {
            console.log(data);
            var output = prettyPrint(data);
            $("#results").html(output);
            for (var i = 0; i < 10; i++) {
                $("#txtArea").append(data.businesses[i].name);
            }}*/
    });
}

//increments voteCountArray for venue at specific index
function voteClick(index) {
    voteCountArray[index] += 1;
    var votes = parseInt($(".voteCount").eq(index).text());
    $(".voteCount").eq(index).text(votes + 1);

    var $list = $("#venueList .listItem");

    $list.sort(function(a, b) {
        var aVotes = $(a).children("div.voteCount").text();
        var bVotes = $(b).children("div.voteCount").text();

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

//countdown timer for upcoming events
function updateCountdown(d) {
    var currentDate = new Date();
    var timeMS = Math.abs(d - currentDate);
    var seconds = Math.round(timeMS/1000);
    var minutes = Math.floor(seconds/60);
    seconds %= 60;
    var hours = Math.floor(minutes/60);
    minutes %= 60;
    var days = Math.floor(hours/24);
    hours %= 24;

    $("#eventTimer").html(days + ((days === 1) ? " Day": " Days") + '<br/>' + numChecker(hours) + ":" + numChecker(minutes) + ":" + numChecker(seconds));


}

//converts numbers to two digit strings for countdown timer
function numChecker(num) {
    if(num <10){
        return "0" + num;
    }
    return num;
}

/********************
'mmObject' DEFINITION: STORES ALL THE INFO FOR A GIVEN USER-CREATED EVENT
*********************/
function mmObject(eventName, eventDate, eventOwner) {

    this.name = eventName;
    this.date = eventDate;
    this.owner = eventOwner;
    this.init = init;
    this.changeEventDate = changeEventDate;
    this.changeEventName = changeEventName;
    this.addVenue = addVenue;


    function init() {
        var d = this.date;
        var t = setInterval(function() {updateCountdown(d)} , 1000);
        publishEventInfo();
        $("form#venueEntry").submit(function(event) {
            addVenue(event);
        });
    }

    function changeEventDate(newdate) {
        this.date = newdate;
        publishEventInfo();
        var t = setInterval(function() {updateCountdown(newdate)} , 1000);
    }

    function changeEventName(newname) {
        this.name = newname;
        publishEventInfo();
    }

    function publishEventInfo() {
        $("#userEntry h3").text('"' + eventName + '"' + " " + (numChecker(eventDate.getMonth()+1)) + "-" + numChecker(eventDate.getDate()) + "-" + eventDate.getFullYear());
        $("#eventNameHeader").text('"' + eventName + '"' + " " + (numChecker(eventDate.getMonth()+1)) + "-" + numChecker(eventDate.getDate()) + "-" + eventDate.getFullYear());
    }

    //adds venue to venueList element
    function addVenue(event) {
        console.log("poop");
        event.preventDefault();

        //check that fields are completed
        if($("#venueName").val() === "" || $("#venueInfo").val() === "") {
            alert ("One or more required fields is empty");
        }
        else {
            venueCount = voteCountArray.push(0);

            //var userName = prompt("Please enter your name:");
            //if(userName !== "" && userName !== null) {
                $("#venueList ul").append('<li class="listItem"><div class = "venueSticky">' +
                    $("#venueName").val() + '<br/>' + $("#venueInfo").val()+ '<br/>' + '(' + $("#venueDropDown").val() +')' + '<br/>' + '<div align="right">- ' + eventOwner + ' -</div><br/>'+
                    '</div><button class = \"voteButton\" onclick = \"voteClick($(\'.voteButton\').index(this))\">VOTE!</button><div class = \"voteCount\">0</div></li>');

                //clear entry fields
                $("#venueEntry")[0].reset();
                //overlay();

            //}
        }

    }
}
/********************
 END 'mmObject' DEFINITION
 *********************/


/********************
 $(document).ready() function
 *********************/
$(function() {
   /* var eventName = "Mo Mondays"
    var d = new Date("2013/01/07 18:00:00");
    var crap = new mmObject(eventName, d, "Satyan");
    crap.init();*/
    AC();
    //create Event form submissions
    $("#eventFormSubmit").click(function (event) {
        event.preventDefault();

        var t = $("#formEventTime").val() + ":00";
        var d = new Date($("#formEventDate").val() + " " + t);

        var newEvent = new mmObject($("#formEventName").val(), d, "userName");
        newEvent.init();
        currentEventsArray.push(newEvent);

        $("#createEventForm form")[0].reset();
        $("#createEventForm a").attr("href", "#" + "mmEvent" + currentEventsArray.indexOf(newEvent));
       // $("#createEventForm a").attr("target", "_blank");
        //$("#createEventForm a").click();

        $(".modalDialog").css("visibility", "hidden");
        $("#userEntryButton").css("visibility", "visible");
    });



/*
    $( "#userEntry" ).dialog({
        autoOpen: true,
        height: 800,
        width: 350,
        modal: true,
        buttons: {
            "Add Venue to List": function() {

            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {

        }
    });

    $( "#entryButton" ).click(function() {
            $( "#userEntry" ).dialog( "open" );
    });

*/

});




