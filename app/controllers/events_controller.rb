class EventsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]


  # GET /events
  # GET /events.json
  def index
    #only display events that are not finished
    @events = Event.find(:all, :conditions => ["stage != ?", "Finished"])
    gon.numEvents = @events.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @venue = Venue.new({:event_id => @event.id})
    @vote_date = @event.event_start - @event.vote_start.days

    if @event.stage == "Pre-Voting"
       @no_venues_text = "No venues have been suggested yet.  Suggest one!"
    elsif @event.stage == "Voting"
           @no_venues_text = "No venues were suggested for this event during the venue suggestion phase.  
           Now only the event owner can suggest venues. When he/she does, you can vote on them"
    else
      @no_venues_text = "No venues were suggested for this event.  The event has been cancelled"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
      format.js
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @event }
      format.js {render action: 'new'}
    end

  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
   
    @event.user = current_user
    @event.stage = "Pre-Voting"

      respond_to do |format|
        if @event.save
          #flash[:alert] = "#{@event.event_start}"
          #AutoMailer.event_create_email(@event.id).deliver
          write_jobs(@event.id)
          @update = Update.create!(:content => "#{current_user} just created a new event: \"#{@event}\"")
          
          format.html { redirect_to events_path, notice: 'Event was successfully created.' }
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
        @update = Update.create!(:content => "#{current_user} just updated \"#{@event}\"")

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
    @update = Update.create!(:content => "#{current_user} just deleted \"#{@event}\"")

    respond_to do |format|
      format.html { redirect_to events_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  #rsvp_yes
  def rsvp_yes
    @event = Event.find(params[:event_id])
    if !user_signed_in?
      #redirect_to @event, notice: "You must be signed in to RSVP."
    else
       @already_rsvp = Rsvp.exists?(:user_id => current_user.id, :event_id => params[:event_id ])

      if (@already_rsvp)
         respond_to do |format|
           format.html {redirect_to @venue.event, notice: "You have already RSVP'd for this event"}
           format.js
         end

      else
        Rsvp.create!(:user_id => current_user.id, :event_id => @event.id)
        Update.create!(:content => "#{current_user} just RSVP'd for \"#{@event.name}\"")

        respond_to do |format|
          format.html {redirect_to @event, notice: "You have successfully RSVP'd to this event."}
          format.js
        end
      end
    end
  end

private

  def write_jobs(event_id)
    @event = Event.find(event_id)

    #delete delayed_jobs if it exists
    destroy_jobs(event_id)

    #rewrite delayed_jobs for updated event
    event_job = Delayed::Job.enqueue(EventFinishJob.new(@event.id), 0, @event.event_start)
    vote_job = Delayed::Job.enqueue(VoteStartJob.new(@event.id), 0, @event.event_start - @event.vote_start.days)

    # save id of delayed job on Event record
    @event.update_attributes(:event_email_job_id => event_job.id)
    @event.update_attributes(:voting_email_job_id => vote_job.id)

  end

  def destroy_jobs(event_id)
    @event = Event.find(event_id)
    if @event.event_email_job_id and Delayed::Job.exists?(@event.event_email_job_id)
      Delayed::Job.find(@event.event_email_job_id).destroy
    end

    if @event.voting_email_job_id and Delayed::Job.exists?(@event.voting_email_job_id)
      Delayed::Job.find(@event.voting_email_job_id).destroy
    end

  end




end
