class UpdatesController < ApplicationController
  def index
  	@updates = Update.new(:content => "This is an update")

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updates }
    end
  end
end
