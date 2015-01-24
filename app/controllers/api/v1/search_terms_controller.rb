class Api::V1::SearchTermsController < ApplicationController

  before_filter :load_query, only: :fetch_data

  # Method to fetch data
  #
  # ==
  # Required Parameters:
  #   :query
  # Method type:
  #   GET
  # Example request:
  #   http://localhost:3000/api/v1/search_terms/fetch_data
  # Success Response
  # {"results":[{"id":6,"name":"Sigmund Leannon DVM","industry":{"id":2,"name":"Kaya Trantow"}},{"id":46,"name":"Shakira Anderson","industry":{"id":2,"name":"Kaya Trantow"}},{"id":56,"name":"Shane Weissnat V","industry":{"id":3,"name":"Stephen Hackett"}},{"id":64,"name":"Shane Veum","industry":{"id":3,"name":"Stephen Hackett"}},{"id":72,"name":"Saige Kerluke","industry":{"id":3,"name":"Stephen Hackett"}},{"id":110,"name":"Stevie Gulgowski","industry":{"id":4,"name":"Salvatore Gleason"}}],"status":"ok"}

  def fetch_data
    #Don't hardcode limits but move it to optional parameters
    @businesses = Business.where("name like ? and industry_id IS NOT NULL", @query).limit(6)
    selected_industries = @businesses.pluck(:industry_id).presence || [0]
    @industries = Industry.where("name like ? and id NOT IN (?)", @query, selected_industries).limit(8 - @businesses.length)
    render json: { results: business_json + industry_json, status: :ok }
  end

  private
    #Fetch Business JSON (User jbuilder or active record serializer for it)
    def business_json
      @businesses.as_json(only: [:name, :id], include: { industry: { only: [:id, :name] }})
    end

    #Fetch Industry JSON
    def industry_json
      @industries.as_json(only: [:name, :id])
    end

    #load query before making the search
    def load_query
      if params[:query] && params[:query].squish.present?
        @query = params[:query].squish.humanize + '%'
      else
        render json: { message: 'No Query Parameter' , status: :unprocessable_entity }
        return false
      end
    end
end