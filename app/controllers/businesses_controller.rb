class BusinessesController < ApplicationController
  # Show page for business resource
  # Assumption - Record will be found, case not handeled for when record not found
  def show
    @business = Business.find(params[:id])
  end
end
