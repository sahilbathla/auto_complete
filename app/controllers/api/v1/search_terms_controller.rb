class Api::V1::SearchTermsController < ApplicationController

  def fetch_data
    if params[:query].squish.present?
      query = params[:query].squish.humanize + '%'
      @businesses = Business.where("name like ? and industry_id IS NOT NULL", query).limit(6)
      selected_industries = @businesses.pluck(:industry_id).presence || [0]
      @industries = Industry.where("name like ? and id NOT IN (?)", query, selected_industries).limit(8 - @businesses.length)
      render json: { results: business_json + industry_json, status: :ok }
    else
      render json: [], status: :unprocessable_entity
    end
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
end