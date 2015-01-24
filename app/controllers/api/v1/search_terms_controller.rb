class Api::V1::SearchTermsController < ApplicationController
  def fetch_data
    if params[:query]
      query = params[:query].squish.downcase
      @businesses = Business.where("LOWER(name) like '#{ query }%' and industry_id IS NOT NULL").limit(6)
      selected_industries = @businesses.pluck(:industry_id)
      @industries = Industry.where("LOWER(name) like '#{ query }%' and id NOT IN (?)", selected_industries).limit(8 - @businesses.count)
      render json: { results: business_json + industry_json, status: :ok }
    else
      render json: [], status: :unprocessable_entity
    end
  end

  private
    def business_json
      @businesses.as_json(only: [:name, :id], include: { industry: { only: [:id, :name] }})
    end

    def industry_json
      @industries.as_json(only: [:name, :id])
    end
end