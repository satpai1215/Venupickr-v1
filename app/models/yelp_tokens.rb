module YelpTokens

	TOKENS = {
	    consumerKey: ENV['YELP_CONSUMERKEY'],
        consumerSecret: ENV['YELP_CONSUMERSECRET'],
        accessToken: ENV['YELP_ACCESSTOKEN'],
        accessTokenSecret: ENV['YELP_ACCESSTOKENSECRET']
    }.freeze

end