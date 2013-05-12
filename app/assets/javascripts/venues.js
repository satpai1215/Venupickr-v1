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