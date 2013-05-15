-Validate upon change of event date
- redirect on sign in to previous page
- highlight winning venue on Event Finished page
- add graphic for loading (esp when events are created to prevent double submission)
- What to do if event has no venues suggested and countdown ends
- have a checkbox to determine if people other than event_owner can suggest venues



No Venue Suggested Exception:
	- Catch in VoteStartJob, check for venues.count == 0
	- If venues.count == 0, email owner (no_venue_email) to warn them to add venues (need to add suggest venue button)
	- Owner can add venues throughout voting process
	- Catch in EventFinishJob that venues == 0, email owner (no_venue_email_final).  Archive event as "Finished"
	- 