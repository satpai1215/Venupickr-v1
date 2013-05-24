- Validate upon change of event date (disabled)
- redirect on sign in to previous page (done)
- highlight winning venue on Event Finished page  (done)
- add graphic for loading (esp when events are created to prevent double submission)
- What to do if event has no venues suggested and countdown ends (done)
- have a checkbox to determine if people other than event_owner can suggest venues (optional)
- email users when events are created (tell them to suggest venues)
- allow users to remove name from RSVP list (done)



No Venue Suggested Exception:
	- Catch in VoteStartJob, check for venues.count == 0
	- If venues.count == 0, email owner (no_venue_email) to warn them to add venues (need to add suggest venue button)
	- Owner can add venues throughout voting process
	- Catch in EventFinishJob that venues == 0, email owner (no_venue_email_final).  Archive event as "Finished"
	- 