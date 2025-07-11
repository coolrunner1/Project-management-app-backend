class TempController < ApplicationController

  # GET /temp
  def index
    render json: {"temp": "temp"}
  end
end
