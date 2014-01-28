class VenuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_venue, :only => [:edit, :update, :destroy]
  before_filter :auth_owner, :only => [:edit, :update, :destroy]

  def get_venue
    @venue = Venue.find(params[:id])
  end

  def auth_owner
    if !(current_user.id == @venue.user.id or current_user.uid == "4802244")
      redirect_to @event, notice: 'You are not authorized to carry out that action.'
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
    @event = Event.find(params[:event_id])

    if (@event.allow_venue_suggestion or current_user.id === @event.owner_id)
      @already_suggested_venue = Venue.exists?(:user_id => current_user.id, :event_id => @event.id)

      #only allow multiple venue suggestion if user is event owner
      if @already_suggested_venue and (current_user.id != @event.owner_id)
        respond_to do |format|
          format.html { redirect_to event_path(@event.id),
                        notice: "You have already suggested a venue for this event. Try removing your existing venue."}
          format.js
        end
      else
        @venue = @event.venues.build
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @venue }
          format.js
        end
      end

    else #venue_suggestion turned off
      redirect_to event_path(@event_id), notice: "The owner has turned off venue suggestion for this event."
    end
  end

  # GET /venues/1/edit
  def edit
    @event = Event.find(params[:event_id])

    if current_user.id == @venue.user.id
      @venue.address = @venue.address.gsub("<br>", "\n").html_safe

      respond_to do |format|
        format.html # edit.html.erb
        format.json { render json: @venue }
        format.js {render action: 'new'}
      end
    else
      redirect_to @event, notice: 'You are not authorized to access that page.'
    end

  end

  # POST /venues
  # POST /venues.json
  def create
    @event = Event.find(params[:event_id])
    @venue = @event.venues.build(params[:venue])
    @venue.address = @venue.address.gsub("\n", "<br>").html_safe

    if(@event != nil)
      @venue.user = current_user
      #@venue.votecount = 1

      respond_to do |format|
        if @venue.save
          #automatically votes for suggested venue if not already voted for this event
          if !Voter.exists?(:user_id => current_user.id, :event_id => @event.id)
            Voter.create!(:user_id => current_user.id, :event_id => @event.id, :venue_id => @venue.id)
            @venue.update_column(:votecount, 1)
          end

          @content = "#{current_user} just suggested a venue"
          @update = Update.create!(:content => "#{current_user} just suggested a venue for \"#{@venue.event}\"", :event_id => @venue.event.id)
          @comment = Comment.create!(:content => @content, :event_id => @event.id)

          if(@venue.event.owner_id != current_user.id)
            AutoMailer.venue_suggested_email_owner(@event.id, @venue.user.id).deliver
          end
            AutoMailer.venue_suggested_email_guest(@event.id, @venue.user.id).deliver
          
          format.html { redirect_to @event, notice: 'Venue added successfully.' }
          format.json { render json: @event, status: :created, location: @event }
          format.js
        else
         # @event_id = @venue.event.id
          format.html { render action: "new"}
          format.json { render json: @venue.errors, status: :unprocessable_entity }
          format.js {render action: "new"}
        end
      end

    #checks that new venue is linked to an event, not just created via URL
    else
      redirect_to events_path, notice: 'You are not allowed to do this.'
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue.assign_attributes(params[:venue])
    @venue_changed = @venue.changed? #checks is the venue was actually modified or not

    if(@venue_changed)
        #reset votecount for venue if it is modified
        @venue.assign_attributes(:votecount => 0)

        #remove voting records for venue if it is modified
        Voter.destroy_all(:venue_id => @venue.id)
        @venue.update_column(:votecount, 0)

        #checks if user voted for another venue, if not vote for this one
        if !Voter.exists?(:user_id => current_user.id, :event_id => @venue.event.id)
            Voter.create!(:user_id => current_user.id, :event_id => @venue.event.id, :venue_id => @venue.id)
        end

        @content = "#{current_user} modified a venue"
        @update = Update.create!(:content => "#{current_user} just modified a venue for \"#{@venue.event}\"", :event_id => @venue.event.id)
        @comment = Comment.create!(:content => @content, :event_id => @venue.event.id)

        if(@venue.event.owner_id != current_user.id)
          AutoMailer.venue_suggested_email(@venue.event.id, @venue.id).deliver
        end
    end

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue.event, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
        format.js #{ render :js => %(window.location = '#{event_path(@venue.event.id)}')}
      else
        @event_id = @venue.event.id
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
        format.js { render action: "new" }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])

    @content = "#{current_user} deleted a venue"
    @update = Update.create!(:content => "#{current_user} just deleted a venue for \"#{@venue.event}\"", :event_id => @venue.event.id)
    @comment = Comment.create!(:content => @content, :event_id => @venue.event.id)


    respond_to do |format|
      format.html { redirect_to @venue.event, notice: "You have successfully removed your suggested venue" }
      format.js
      format.json { head :no_content }
    end
      @venue.destroy
  end

  def increment_vote

    if !user_signed_in?
      #redirect_to @venue.event, notice: "You must be signed in to vote."
    else

       @venue = Venue.find(params[:venue_id])
       @event = @venue.event
       @already_voted = Voter.exists?(:user_id => current_user.id, :venue_id => params[:venue_id ])

       @show_votecounts = (current_user.id == @venue.event.owner_id or current_user.uid == "4802244")

      #user has already voted for this venue
      if (@already_voted)
         respond_to do |format|
           format.html {redirect_to @event, notice: "You have already voted for this venue"}
           format.js {render :js => %($("#notice").text("You have already voted for this venue");)}
         end
      else
        @notice_text = "Your vote has been recorded."
        #if user already voted for this event, remove previouv vote associate
        @voter = Voter.where(:user_id => current_user.id, :event_id => params[:event_id]).first
        if !@voter.nil?
          @previous_venue = Venue.find(@voter.venue_id)
          @voter.destroy
          @previous_votecount = @previous_venue.voters.count
          @notice_text = "You have successfully changed your vote."
          @content = "#{current_user} changed their vote"
        else
          @content = "#{current_user} cast a vote"
        end


        #create new vote association
        #num = @venue.votecount + 1
        #@venue.update_attributes(:votecount => num )

        Voter.create!(:user_id => current_user.id, :event_id => @venue.event.id, :venue_id => @venue.id)
        @venue.update_column(:votecount, @venue.voters.count + 1)

        @update = Update.create!(:content => @content + " for the event: \"#{@venue.event}\"", :event_id => @venue.event.id)
        @comment = Comment.create!(:content => @content, :event_id => @venue.event.id)

        @votecount = @venue.voters.count
        @total_votecounts = @event.voters.count
        
        respond_to do |format|
            format.html {redirect_to @venue.event, notice: "#{@notice_text}"}
           format.js #increment_vote.js.erb
        end
      end
    end

  end

end
