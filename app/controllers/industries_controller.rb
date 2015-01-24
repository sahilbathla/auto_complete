class IndustriesController < ApplicationController
  def show
    @industry = Industry.find(params[:id])
  end
end
