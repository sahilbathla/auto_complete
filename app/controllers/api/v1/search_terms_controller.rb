class Api::V1::SearchTermsController < ApplicationController
  def fetch_data
    unless params[:query].squish.empty?
      query = params[:query].squish.humanize
      @businesses = Business.where("name like '#{ query }%' and industry_id IS NOT NULL").limit(6)
      selected_industries = [0] + @businesses.pluck(:industry_id)
      @industries = Industry.where("name like '#{ query }%' and id NOT IN (?)", selected_industries).limit(8 - @businesses.length)
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