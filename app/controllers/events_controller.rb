
class EventsController < ApplicationController
  before_filter :authenticate_user!


  # GET /events
  # GET /events.json
  def index

      @name_entered = (current_user.firstname.nil? or current_user.lastname.nil?)
      #only show events that user is a guest of
      @events = current_user.events.where(:stage => "Voting").order("event_start ASC")
      @upcoming_events = current_user.events.where(:stage => "Finished").order("event_start ASC")
      gon.numUpcoming = @upcoming_events.count
      gon.totalIndexEvents = @upcoming_events.count + @events.count

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @events }
      end

  end

  # GET /events/1
  # GET /events/1.json
  def show  
    @event = Event.find(params[:id])
    #if Guest.where(:user_id => current_user.id, :event_id => @event.id).first.nil?
    if !current_user.invited?(@event)
       redirect_to events_path, notice: 'You do not have access that page.'
    else
      @owner = @event.owner
      @owner_as_guest = Guest.where(:user_id => @event.owner_id, :event_id => @event.id).first
      @current_user_as_guest = Guest.where(:user_id => current_user.id, :event_id => @event.id).first
      @guests = @event.guests - [@owner_as_guest] #remove owner from guestlist
      #only show vote counts if voting period is over, or if user is event owner or admin
      @show_votecounts =  (@event.stage != "Voting" or current_user.id == @owner.id or current_user.username == "Spaiderman")
      #@vote_date = @event.event_start - @event.vote_start.days

      if @event.stage == "Voting"
         @no_venues_text = "No venues have been suggested yet.  Suggest one!"
      else
        @no_venues_text = "No venues were suggested for this event.  The event has been cancelled"
      end
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @event }
      end
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @vote_end = 3

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
      format.js
    end
  end


  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    if current_user.id == @event.owner_id or current_user.username == "Spaiderman"
      #convert event_start back into date and time components
      @event.datepicker = @event.event_start.strftime("%m/%d/%Y")
      @event.timepicker = @event.event_start.strftime("%I:%M%p")
      @vote_end = @event.vote_end


      respond_to do |format|
        format.html # edit.html.erb
        format.json { render json: @event }
        format.js
      end
    else
      redirect_to @event, notice: 'You are not authorized to access that page.'
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    #save event owner as current_user
    @event.owner_id = current_user.id

    #add current_user to guests of this event
    @event.users << current_user

      respond_to do |format|
        if @event.save
          #AutoMailer.event_create_email(@event.id).deliver
          write_jobs(@event.id)
          @update = Update.create!(:content => "#{current_user} just created a new event: \"#{@event}\"", :event_id => @event.id)

          flash[:new_event?] = true; #sends message to event#show to open guestlist dialog

          format.html { redirect_to @event, notice: 'Event was successfully created.'}
          format.json { render json: @event, status: :created, location: @event }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
          format.js {render action: "new"}
        end
      end

  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @content = "#{current_user} updated the event"
        @update = Update.create!(:content => "#{current_user} just updated \"#{@event}\"", :event_id => @event.id)
        @comment = Comment.create!(:content => @content, :event_id => @event.id)


        write_jobs(@event.id)

        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
        format.js {render :js => %(window.location = '#{event_path(@event.id)}')}
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js { render action: "new" }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    destroy_jobs(@event.id)
    @event.destroy
    @update = Update.create!(:content => "#{current_user} just deleted \"#{@event}\"", :event_id => @event.id)

    respond_to do |format|
      format.html { redirect_to events_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  #rsvp_yes
  def rsvp_yes
    @guest = Guest.find(params[:guest_id])

      if (!@guest)
         respond_to do |format|
           format.html {redirect_to @venue.event, notice: "You are not a guest for this event."}
           format.js
         end
      else
        @guest.update_column(:isgoing, true)
        respond_to do |format|
          format.html {redirect_to @event, notice: "You have successfully RSVP'd to this event."}
          format.js
        end
      end
  end

  def rsvp_no
    @guest = Guest.find(params[:guest_id])

      if (!@guest)
         respond_to do |format|
           format.html {redirect_to @venue.event, notice: "You are not a guest for this event."}
           format.js
         end
      else
        @guest.update_column(:isgoing, false)
        respond_to do |format|
          format.html {redirect_to @event, notice: "You are no longer RSVP'd for this event."}
          format.js
        end
      end

  end

  def send_reminder
    @event = Event.find(params[:event_id])
    if @event.stage == "Voting"
      AutoMailer.voting_reminder_email(params[:event_id]).deliver
    elsif @event.stage == "Finished"
      AutoMailer.finished_reminder_email(params[:event_id]).deliver
    else
    end

    respond_to do |format|
      format.html {redirect_to @event, notice: "A reminder email has been sent"}
      format.js {render :js => '$("#notice").text("A reminder email has been sent");'}
    end
  end

  def post_comment
    @event = Event.find(params[:event_id])
    @content = params[:comment]
 
    @comment = Comment.create!(:content => @content, :event_id => params[:event_id], :username => current_user.username)
    Update.create!(:content => "#{current_user} just posted a comment on \"#{@event.name}\"", :event_id => @event.id)

    respond_to do |format|
      format.html {redirect_to event_path(params[:event_id]), notice: "Commented Posted."}
      format.js
    end
  end




private

  def write_jobs(event_id)
    @event = Event.find(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours

    #delete delayed_jobs if it exists
    destroy_jobs(event_id)

    #rewrite delayed_jobs for updated event
    event_job = Delayed::Job.enqueue(EventFinishJob.new(@event.id), 0, @vote_end)
    
    #archived event 4hours after event_start, so people can still see event info on homepage if they are late
    archive_job = Delayed::Job.enqueue(ArchiveJob.new(@event.id), 0, @event.event_start + 4.hours)
    #vote_job = Delayed::Job.enqueue(VoteStartJob.new(@event.id), 0, @event.event_start - @event.vote_start.days)

    # save id of delayed job on Event record
    @event.update_column(:event_email_job_id, event_job.id)
    @event.update_column(:archive_job_id, archive_job.id)
    #@event.update_attributes(:voting_email_job_id => vote_job.id)

  end

  def destroy_jobs(event_id)
    @event = Event.find(event_id)
    if @event.event_email_job_id and Delayed::Job.exists?(@event.event_email_job_id)
      Delayed::Job.find(@event.event_email_job_id).destroy
    end
    if @event.archive_job_id and Delayed::Job.exists?(@event.archive_job_id)
      Delayed::Job.find(@event.archive_job_id).destroy
    end


=begin
    if @event.voting_email_job_id and Delayed::Job.exists?(@event.voting_email_job_id)
      Delayed::Job.find(@event.voting_email_job_id).destroy
    end
=end



  end




end
