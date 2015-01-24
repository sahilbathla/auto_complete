class IndustriesController < ApplicationController
  # Show page for industry resource
  # Assumption - Record will be found, case not handeled for when record not found
  def show
    @industry = Industry.find(params[:id])
  end
end
