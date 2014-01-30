require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "648598512571-p90ii2m86ot9dsr1jkfkljp4fv5rpk6o.apps.googleusercontent.com", "mBs_uL04nAQsAH3EX8LcR2it", max: 5000
end