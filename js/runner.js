var voteCountArray = [];
var venueCount = 0;
var currentEventsArray = [];

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
        event.preventDefault();

        //check that fields are completed
        if($("#venueName").val() === "" || $("#venueLocation").val() === "") {
            alert ("One or more required fields is empty");
        }
        else {
            venueCount = voteCountArray.push(0);

            //var userName = prompt("Please enter your name:");
            //if(userName !== "" && userName !== null) {
                $("#venueList ul").append('<li class="listItem"><div class = "venueSticky">' +
                    $("#venueName").val() + '<br/>' + $("#venueLocation").val()+ '<br/>' + '(' + $("#venueDropDown").val() +')' + '<br/>' + '<div align="right">- ' + eventOwner + ' -</div><br/>'+
                    '</div><button class = \"voteButton\" onclick = \"voteClick($(\'.voteButton\').index(this))\">VOTE!</button><div class = \"voteCount\">0</div></li>');

                //clear entry fields
                $("#venueEntry")[0].reset();
                overlay();

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




