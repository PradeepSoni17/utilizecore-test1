class SearchController < ApplicationController
  def index
    if params[:search].present?
      @parcels = Parcel.where(unique_no: params[:search])
    else
      @parcels = []
    end
  end
end
