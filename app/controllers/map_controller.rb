class MapController < ApplicationController
  def index
    # return JSON of all graduates
  end

  def graduates
    @graduates = Graduate.all
    if request.xhr?
      render json: @graduates
    end
  end
end